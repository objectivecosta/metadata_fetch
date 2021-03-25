import 'package:html/dom.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

/// Does Works with `BaseMetadataParser`
class MetadataParser {
  /// This is the default strategy for building our [Metadata]
  ///
  /// It tries [OpenGraphParser], then [TwitterCardParser], then [JsonLdParser], and falls back to [HTMLMetaParser] tags for missing data.
  static Metadata parse(Document? document) {
    final output = Metadata();

    final parsers = [
      openGraph(document),
      twitterCard(document),
      jsonLdSchema(document),
      htmlMeta(document),
    ];

    for (final p in parsers) {
      output.title ??= p.title;
      output.description ??= p.description;
      output.image ??= p.image;
      output.url ??= p.url;

      if (output.hasAllMetadata) {
        break;
      }
    }
    final url = output.url;
    final image = output.image;
    if (url != null && image != null) {
      output.image = Uri.parse(url).resolve(image).toString();
    }

    return output;
  }

  static Metadata openGraph(Document? document) {
    return OpenGraphParser(document).parse();
  }

  static Metadata htmlMeta(Document? document) {
    return HtmlMetaParser(document).parse();
  }

  static Metadata jsonLdSchema(Document? document) {
    return JsonLdParser(document).parse();
  }

  static Metadata twitterCard(Document? document) {
    return TwitterCardParser(document).parse();
  }
}
