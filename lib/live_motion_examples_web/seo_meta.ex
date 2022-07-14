defmodule LiveMotionExamplesWeb.SeoMeta do
  defstruct [:title, :description, :url, :image_url]

  def page_title(title) do
    title <> " — LiveMotion"
  end

  def seo_meta_attrs(%__MODULE__{} = meta) do
    general_meta_attrs(meta) ++ social_meta_attrs(meta)
  end

  def general_meta_attrs(%__MODULE__{} = meta) do
    [
      %{name: "title", content: meta.title},
      %{name: "description", content: meta.description}
    ]
  end

  def social_meta_attrs(%__MODULE__{} = meta) do
    [
      %{property: "og:type", content: "website"},
      %{property: "og:url", content: meta.url},
      %{property: "og:title", content: meta.title},
      %{property: "og:description", content: meta.description},
      %{property: "og:image", content: meta.image_url},
      %{property: "twitter:card", content: "summary_large_image"},
      %{property: "twitter:url", content: meta.url},
      %{property: "twitter:title", content: meta.title},
      %{property: "twitter:description", content: meta.description},
      %{property: "twitter:image", content: meta.image_url}
    ]
  end
end
