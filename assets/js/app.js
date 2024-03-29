// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html';
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from 'topbar';
import Plausible from 'plausible-tracker';
import { createLiveMotion } from 'live_motion';

const plausible = Plausible({
  domain: 'livemotion.benvp.co',
});

plausible.enableAutoPageviews();

// Syntax highlighting
import Prism from './prism';

const { hook: motionHook, handleMotionUpdates } = createLiveMotion();

const hooks = {
  Prism: {
    mounted() {
      Prism.highlightAll(document.querySelector('pre code'));
    },
    updated() {
      Prism.highlightAll(document.querySelector('pre code'));
    },
  },
  ...motionHook,
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      handleMotionUpdates(from, to);
    },
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#00FFBF' }, shadowColor: 'rgba(0, 0, 0, .3)' });
let topBarScheduled = undefined;

window.addEventListener('phx:page-loading-start', () => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 500);
  }
});

window.addEventListener('phx:page-loading-stop', () => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
