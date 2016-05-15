//
//  TestBasedViewController.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/15/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

class TextBasedViewController: UIViewController {
    
    var textView: MultitouchTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.textView = MultitouchTextView()
        self.textView.clipsToBounds = false
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.textView)
        
        self.setupConstraints()
        
        self.textView.text = self.sampleText()
    }
    
    func setupConstraints() {
        let metrics = ["margin": 25.0]
        let views = ["textView": self.textView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textView]|", options: [], metrics: metrics, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[textView]|", options: [], metrics: metrics, views: views))
    }
}

extension TextBasedViewController {
    func sampleText() -> String {
        return "The UIKit framework includes several classes whose purpose is to display text in an app’s user interface: UITextView, UITextField, UILabel, and UIWebView, as described in Displaying Text Content in iOS. Text views, created from the UITextView class, are meant to display large amounts of text. Underlying UITextView is a powerful layout engine called Text Kit. If you need to customize the layout process or you need to intervene in that behavior, you can use Text Kit. For smaller amounts of text and special needs requiring custom solutions, you can use alternative, lower-level technologies, as described in Lower Level Text-Handling Technologies.\n\nText Kit is a set of classes and protocols in the UIKit framework providing high-quality typographical services that enable apps to store, lay out, and display text with all the characteristics of fine typesetting, such as kerning, ligatures, line breaking, and justification. Text Kit is built on top of Core Text, so it provides the same speed and power. UITextView is fully integrated with Text Kit; it provides editing and display capabilities that enable users to input text, specify formatting attributes, and view the results. The other Text Kit classes provide text storage and layout capabilities. Figure 9-1 shows the position of Text Kit among other iOS text and graphics frameworks.\n\nFigure 9-1  Text Kit Framework Position\n\nText Kit gives you complete control over text rendering in user interface elements. In addition to UITextView, UITextField and UILabel are built on top of Text Kit, and it seamlessly integrates with animations, UICollectionView and UITableView. Text Kit is designed with a fully extensible object-oriented architecture that supports subclassing, delegation, and a thorough set of notifications enabling deep customization.\n\nPrimary Text Kit Objects\n\nThe data flow paths among the primary Text Kit objects are shown in Figure 9-2. Text views are instances of UITextView class, text containers are instances of NSTextContainer class, the layout manager is an instance of NSLayoutManager class, and the text storage is an instance of NSTextStorage class. In Text Kit, an NSTextStorage object stores the text that is displayed by a UITextView object and laid out by an NSLayoutManager object into an area defined by NSTextContainer object.\n\nFigure 9-2  Primary Text Kit Objects\n\nAn NSTextContainer object defines a region where text can be laid out. Typically, a text container defines a rectangular area, but by creating a subclass of NSTextContainer you can create other shapes: circles, pentagons, or irregular shapes, for example. Not only does a text container describe the outline of an area that can be filled with text, it maintains an array of Bezier paths that are exclusion zones within its area where text is not laid out. As it is laid out, text flows around the exclusion paths, providing a means to include graphics and other non-text layout elements.\n\nNSTextStorage defines the fundamental storage mechanism of the Text Kit’s extended text-handling system. NSTextStorage is a subclass of NSMutableAttributedString that stores the characters and attributes manipulated by the text system. It ensures that text and attributes are maintained in a consistent state across editing operations. In addition to storing the text, an NSTextStorage object manages a set of client NSLayoutManager objects, notifying them of any changes to its characters or attributes so that they can relay and redisplay the text as needed.\n\nAn NSLayoutManager object orchestrates the operation of the other text handling objects. It intercedes in operations that convert the data in an NSTextStorage object to rendered text in a view’s display area. It maps Unicode character codes to glyphs and oversees the layout of the glyphs within the areas defined by NSTextContainer objects.\n\nNote: NLayoutManager, NSTextStorage, and NSTextContainer can be accessed from subthreads as long as the app guarantees the access from a single thread.\nFor reference information about UITextView, see UITextView Class Reference. NSTextContainer is described in NSTextContainer Class Reference for iOS, NSLayoutManager in NSLayoutManager Class Reference for iOS, and NSTextStorage in NSTextStorage Class Reference for iOS.\n\nText Attributes\n\nText Kit handles three kinds of text attributes: character attributes, paragraph attributes, and document attributes. Character attributes include traits such as font, color, and subscript, which can be associated with an individual character or a range of characters. Paragraph attributes are traits such as indentation, tabs, and line spacing. Document attributes include documentwide traits such as paper size, margins, and view zoom percentage.\n\nCharacter Attributes\nAn attributed string stores character attributes as key-value pairs in NSDictionary objects. The key is an attribute name, represented by an identifier (an NSString constant) such as NSFontAttributeName. Figure 9-3 shows an attributed string with an attribute dictionary applied to a range within the string.\n\nFigure 9-3  Composition of an attributed string\n\nConceptually, each character in an attributed string has an associated dictionary of attributes. Typically, however, an attribute dictionary applies to a longer range of characters, a run of text. The NSAttributedString class provides methods that take a character index and return the associated attribute dictionary and the range to which its attribute values apply, such as attributesAtIndex:effectiveRange:.\n\nYou can assign any attribute key-value pair you choose to a range of characters, in addition to working with predefined attributes. You add the attributes to the appropriate character range in the NSTextStorage object using the NSMutableAttributedString method addAttribute:value:range:. You can also create an NSDictionary object containing the names and values of a set of custom attributes and add them to the character range in a single step using the addAttributes:range: method. To make use of your custom attributes, you need a custom subclass of NSLayoutManager to work with them. Your subclass should override the drawGlyphsForGlyphRange:atPoint: method. Your override can first call the superclass to draw the glyph range and then draw your own attributes on top. Alternatively, your override can draw the glyphs entirely your own way.\n\nParagraph Attributes\nParagraph attributes affect the way the layout manager arranges lines of text into paragraphs on a page. The text system encapsulates paragraph attributes in objects of the NSParagraphStyle class. The value of one of the predefined character attributes, NSParagraphStyleAttributeName, points to an NSParagraphStyle object containing the paragraph attributes for that character range. Attribute fixing ensures that only one NSParagraphStyle object pertains to the characters throughout each paragraph.\n\nParagraph attributes include traits such as alignment, tab stops, line-breaking mode, and line spacing (also known as leading).\n\nDocument Attributes\nDocument attributes pertain to a document as a whole. Document attributes include traits such as paper size, margins, and view zoom percentage. Although the text system has no built-in mechanism to store document attributes, NSAttributedString initialization methods such as initWithRTF:documentAttributes: can populate an NSDictionary object that you provide with document attributes derived from a stream of RTF or HTML data. Conversely, methods that write RTF data, such as RTFFromRange:documentAttributes:, write document attributes if you pass a reference to an NSDictionary object containing them with the message.\n\nAttribute Fixing\nEditing attributed strings can cause inconsistencies that must be cleaned up by attribute fixing. The UIKit extensions to NSMutableAttributedString define the fixAttributesInRange: method to fix inconsistencies among attachment, character, and paragraph attributes. These methods ensure that attachments don’t remain after their attachment characters are deleted, that character attributes apply only to characters available in that font, and that paragraph attributes are consistent throughout paragraphs.\n\nChanging Text Storage Programmatically\n\nAn NSTextStorage object serves as the character data repository for Text Kit. The format for this data is an attributed string, which is a sequence of characters (in Unicode encoding) and associated attributes (such as font, color, and paragraph style). The classes that represent attributed strings are NSAttributedString and NSMutableAttributedString, of which NSTextStorage is a subclass. As described in Character Attributes, each character in a block of text has a dictionary of keys and values associated with it. A key names an attribute (such as NSFontAttributeName), and the associated value specifies the characteristics of that attribute (such as Helvetica 12-point).\n\nThere are three stages to editing a text storage object programmatically. The first stage is to send it a beginEditing message to announce a group of changes.\n\nIn the second stage, you send it some editing messages, such as replaceCharactersInRange:withString: and setAttributes:range:, to effect the changes in characters or attributes. Each time you send such a message, the text storage object invokes edited:range:changeInLength: to track the range of its characters affected since it received the beginEditing message.\n\nIn the third stage, when you’re done changing the text storage object, you send it an endEditing message. This causes it to sends out the delegate message textStorage:willProcessEditing:range:changeInLength: and invoke its own processEditing method, fixing attributes within the recorded range of changed characters. See Attribute Fixing for information about attribute fixing.\n\nAfter fixing its attributes, the text storage object sends the delegate method textStorage:didProcessEditing:range:changeInLength:, giving the delegate an opportunity to verify and possibly change the attributes. (Although the delegate can change the text storage object’s character attributes in this method, it cannot change the characters themselves without leaving the text storage in an inconsistent state.) Finally, the text storage object sends the processEditingForTextStorage:edited:range:changeInLength:invalidatedRange: message to each associated layout manager—indicating the range in the text storage object that has changed, along with the nature of those changes. The layout managers in turn use this information to recalculate their glyph locations and redisplay if necessary.\n\nWorking with Font Objects\n\nA computer font is a data file in a format such as OpenType or TrueType, containing information describing a set of glyphs, as described in Characters and Glyphs, and various supplementary information used in glyph rendering. The UIFont class provides the interface for getting and setting font information. A UIFont instance provides access to the font’s characteristics and glyphs. Text Kit combines character information with font information to choose the glyphs used during text layout. You use font objects by passing them to methods that accept them as a parameter. Font objects are immutable, so it is safe to use them from multiple threads in your app.\n\nYou don’t create UIFont objects using the alloc and init methods; instead, you use preferredFontForTextStyle: with a text style constant or fontWithName:size:. You can also use a font descriptor to create a font with fontWithDescriptor:size:. These methods check for an existing font object with the specified characteristics, returning it if there is one. Otherwise, they look up the font data requested and create the appropriate font object.\n\nText Styles\nText styles, introduced in iOS 7, are semantic descriptions of the intended uses for fonts and are implemented by a mechanism known as Dynamic Type. Text styles are organized by use and represented by constants defined in UIFontDescriptor.h, as shown in Table 9-1. The actual font used for the purpose described by a text style can vary based on a number of dynamic considerations, including the user’s content size category preference, which is represented by the UIApplication property preferredContentSizeCategory. To acquire a font object for a given text style, you pass the corresponding constant to the UIFont method preferredFontForTextStyle:. To acquire a font descriptor for a text style, pass the constant to the UIFontDescriptor method preferredFontDescriptorWithTextStyle:. (See Using Font Descriptors for more information about font descriptors.)\n\nTable 9-1  Text style constants\nConstant\nUsage\nUIFontTextStyleHeadline\nThe font used for headings.\nUIFontTextStyleSubheadline\nThe font used for subheads.\nUIFontTextStyleBody\nThe font used for body text.\nUIFontTextStyleFootnote\nThe font used for footnotes.\nUIFontTextStyleCaption1\nThe font used for standard captions.\nUIFontTextStyleCaption2\nThe font used for alternate captions.\nText styles bring many advantages to apps through the Dynamic Type mechanism, all of which enhance the readability of your text. Dynamic Type responds in a coordinated way to user preferences and responds to accessibility settings for enhanced legibility and oversize type. That is, when you call preferredFontForTextStyle:, the specific font returned includes traits which vary according to user preferences and context, including tracking (letter-spacing) adjustments, in addition to being tuned for the use specified by the particular text style constant.\n\nThe fonts returned using text style constants are meant to be used for all text in an app other than text in user interface elements, such as buttons, bars, and labels. Naturally, you need to choose text styles that look right in your app. It’s also important to observe the UIContentSizeCategoryDidChangeNotification so that you can re–lay out the text when the user changes the content size category. When your app receives that notification, it should send the invalidateIntrinsicContentSize message to views positioned by Auto Layout or send setNeedsLayout to user interface elements positioned manually. And it should invalidate preferred fonts or font descriptors and acquire new ones as needed.\n\nUsing Font Descriptors\nFont descriptors, instantiated from the UIFontDescriptor class, provide a way to describe a font with a dictionary of attributes and are used to create UIFont objects. In particular, you can make a UIFont object from a font descriptor, you can get a descriptor from a UIFont object, and you can change a descriptor and use it to make a new font object. You can also use a font descriptor to specify custom fonts provided by an app.\n\nFont descriptors can be archived, which is an advantage working with text styles. You should not cache font objects specified by text styles because they are dynamic—their characteristics vary over time according to user preferences. But you can cache a font descriptor to preserve a description of a font, and then unarchive it later and use it to create a font object with the same characteristics.\n\nYou can use font descriptors to query the system for available fonts that match particular attributes, and then create instances of fonts matching those attributes, such as names, traits, languages, and other features. For example, you can use a font descriptor to retrieve all the fonts matching a given font family name, using the family names defined by the CSS standard, as shown in Listing 9-1."
    }
}