//
//  ListingResponse.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/17/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

struct ListingResponse: Codable {
    let kind: String
    let data: ListingData
}

struct ListingData: Codable {
    let modhash: String
    let children: [ListingChild]
    let after: String?
    let before: String?
}

struct ListingChild: Codable {
    /// t1 - Comment, t2 - Account, t3 - Link, t4 - Message, t5 - Subreddit, t6 - Award
    let kind: String
    let data: ListingChildData
}

struct ListingChildData: Codable {
    /// the account name of the poster. null if this is a promotional link
    let author: String?
    /// the CSS class of the author's flair. subreddit specific
    let authorFlairCSSClass: String?
    /// the text of the author's flair. subreddit specific
    let authorFlairText: String?
    /// probably always returns false
    let clicked: Bool
    /// the domain of this link. Self posts will be self.<subreddit> while other examples include en.wikipedia.org and s3.amazon.com
    let domain: String
    /// true if the post is hidden by the logged in user. false if not logged in or not hidden.
    let hidden: Bool
    /// true if this link is a selfpost
    let isSelf: Bool
    /// how the logged-in user has voted on the link - True = upvoted, False = downvoted, null = no vote
    let likes: Bool?
    /// the CSS class of the link's flair.
    let linkFlairCssClass: String?
    /// the text of the link's flair.
    let linkFlairText: String?
    /// whether the link is locked (closed to new comments) or not.
    let locked: Bool
    /// the number of comments that belong to this link. includes removed comments.
    let numComments: Int
    /// true if the post is tagged as NSFW. False if otherwise
    let over18: Bool
    /// relative URL of the permanent link for this link
    let permalink: String
    /// true if this post is saved by the logged in user
    let saved: Bool
    /// the net-score of the link. note: A submission's score is simply the number of upvotes minus the number of downvotes. If five users
    /// like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not "real" numbers, they
    /// have been "fuzzed" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users
    /// downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is
    /// correct, but the vote totals are "fuzzed".
    let score: Int
    /// the raw text. this is the unformatted text which includes the raw markup characters such as ** for bold. <, >, and & are escaped.
    /// Empty if not present.
    let selfText: String
    /// the formatted escaped HTML text. this is the HTML formatted version of the marked up text. Items that are boldened by ** or ***
    /// will now have <em> or *** tags on them. Additionally, bullets and numbered lists will now be in HTML list format.
    /// NOTE: The HTML string will be escaped. You must unescape to get the raw HTML. Null if not present.
    let selftextHTML: String?
    /// subreddit of thing excluding the /r/ prefix. "pics"
    let subreddit: String
    /// the id of the subreddit in which the thing is located
    let subredditId: String
    /// full URL to the thumbnail for this link; "self" if this is a self post; "image" if this is a link to an image but has no thumbnail;
    /// "default" if a thumbnail is not available
    let thumbnail: String
    /// the title of the link. may contain newlines for some reason
    let title: String
    /// the link of this post. the permalink if this is a self-post
    let url: String
    /// to allow determining whether they have been distinguished by moderators/admins. null = not distinguished. moderator = the green [M].
    /// admin = the red [A]. special = various other special distinguishes http://bit.ly/ZYI47B
    let distinguished: String?
    /// true if the post is set as the sticky in its subreddit.
    let stickied: Bool
    /// the number of upvotes. (includes own)
    let ups: Int
    /// the number of downvotes. (includes own)
    let downs: Int
    /// the time of creation in local epoch-second format. ex: 1331042771.0
    let created: Double
    /// the time of creation in UTC epoch-second format. Note that neither of these ever have a non-zero fraction.
    let createdUTC: Double
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorFlairCSSClass = "author_flair_css_class"
        case authorFlairText = "author_flair_text"
        case clicked, domain, hidden
        case isSelf = "is_self"
        case likes
        case linkFlairCssClass = "link_flair_css_class"
        case linkFlairText = "link_flair_text"
        case locked
        case numComments = "num_comments"
        case over18 = "over_18"
        case permalink, saved, score
        case selfText = "selftext"
        case selftextHTML = "selftext_html"
        case subreddit
        case subredditId = "subreddit_id"
        case thumbnail, title, url, distinguished, stickied, ups, downs, created
        case createdUTC = "created_utc"
    }
}
