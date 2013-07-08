subscriptions = JSON.parse(localStorage.getItem("subscriptions")) || []
start_folder = "apple"
currentFeedUrl=""

toggleAddBox = () ->
    btnOffset = $(@).offset()
    style =
      top: btnOffset.top + $(@).height()
      left: btnOffset.left
    $("#quick-add-bubble-holder").css(style).toggleClass('hidden')
    $('#quickadd').val('').focus()

toggleStar = (obj, item) ->
    obj.find("div.entry-icons div").toggleClass("item-star")
    obj.find("div.entry-icons div").toggleClass("item-star-active")

    obj.find("div.entry-actions span:first").toggleClass("item-star")
    obj.find("div.entry-actions span:first").toggleClass("item-star-active")

showDetail = (obj, item) ->
    obj.toggleClass("expanded")
    obj.addClass("read")

    if obj.attr("id") != "current-entry"
        if $("#current-entry").hasClass("expanded")
            $("#current-entry").find("div:first").click()
        $("#current-entry").attr("id", "")
        obj.attr("id", "current-entry")

    if obj.find(".entry-container").length > 0
        obj.find(".entry-container").remove()
        obj.find(".entry-actions").remove()
        return

    date = item.publishedDate
    link = item.link
    title = item.title
    desc = item.contentSnippet
    content = item.content

    entry_container = $(sprintf('<div class="entry-container"><div class="entry-main"><div class="entry-date">%s</div><h2 class="entry-title"><a class="entry-title-link" target="_blank" href="%s">%s<div class="entry-title-go-to"></div></a><span class="entry-icons-placeholder"></span></h2><div class="entry-author"><span class="entry-source-title-parent">来源：<a class="entry-source-title" target="_blank" href=""></a></span> </div><div class="entry-debug"></div><div class="entry-annotations"></div><div class="entry-body"><div><div class="item-body"><div>%s</div></div></div></div></div></div>', date, link, title, content))
    entry_actions = $('<div class="entry-actions"><span class="item-star star link unselectable" title="加注星标"></span><wbr><span class="item-plusone" style="height: 15px; width: 70px; display: inline-block; text-indent: 0px; margin: 0px; padding: 0px; background-color: transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline; background-position: initial initial; background-repeat: initial initial;"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" scrolling="no" style="position: absolute; top: -10000px; width: 70px; margin: 0px; border-style: none;" tabindex="0" vspace="0" width="100%" id="I6_1364822093465" name="I6_1364822093465" allowtransparency="true" data-gapiattached="true"></iframe></span><wbr><span class="email"><span class="link unselectable">电子邮件</span></span><wbr><span class="read-state-not-kept-unread read-state link unselectable" title="保持为未读状态">保持为未读状态</span><wbr><span></span><wbr><span class="tag link unselectable"><span class="entry-tagging-action-title">修改标签: </span><ul class="user-tags-list"><li><a href="/reader/view/user%2F-%2Flabel%2FIT.%E6%95%B0%E7%A0%81">IT.数码</a></li></ul></span></div>')
    obj.append(entry_container)
    obj.append(entry_actions)

showContent = (feedUrl) ->
    feed = JSON.parse(localStorage.getItem(feedUrl))
    $("#entries").addClass("single-source")
    $("#entries").find(".entry").remove()
    $("#title-and-status-holder").css("display", "block")
    $("#chrome-title").html(sprintf('<a target="_blank" href="%s">%s<span class="chevron">»</span></a>', feed.link, feed.title))
    $("#chrome-view-links").css("display", "block")
    currentFeedUrl = feedUrl
    generateContentList(feed.entries)

showFolderContent = (dict) ->
    $("#entries").removeClass("single-source")
    $("#entries").find(".entry").remove()
    $("#title-and-status-holder").css("display", "block")
    $("#chrome-title").html(dict.title)
    $("#chrome-view-links").css("display", "block")
    #entries = []
    for item in dict.item
            #entries.concat(JSON.parse(localStorage.getItem(item.feedUrl)).entries)
            entries = JSON.parse(localStorage.getItem(item.feedUrl)).entries
            generateContentList(entries)

toggleShortcutMap = () ->

    div = $('<div class="banner banner-background keyboard-help-banner"></div>')
    div2 = $('<div class="banner banner-foreground keyboard-help-banner"></div>')
    content = $('''
        <div class="primary-message">键盘快捷键</div>
        <div class="secondary-message">
        <div id="keyboard-help-container">
        <table id="keyboard-help"><tbody><tr><td class="help-section"><table><tbody><tr><th colspan="2">浏览</th></tr>
        <tr><td class="key">j/k：</td>
        <td class="desc">下一个/上一个条目</td></tr>
        <tr><td class="key">空格：</td>
        <td class="desc">下一个条目或页面</td></tr>
        <tr><td class="key">&lt;Shift&gt; + 空格：</td>
        <td class="desc">上一个条目或页面</td></tr>
        <tr><td class="key">n/p：</td>
        <td class="desc">向下/向上扫描条目（仅列表）</td></tr>
        <tr><td class="key">&lt;Shift&gt; + n/p：</td>
        <td class="desc">下一个/上一个订阅</td></tr>
        <tr><td class="key">&lt;Shift&gt; + x：</td>
        <td class="desc">展开文件夹</td></tr>
        <tr><td class="key">&lt;Shift&gt; + o：</td>
        <td class="desc">打开订阅或文件夹</td></tr></tbody></table></td>
        <td class="help-section"><table><tbody><tr><th colspan="2">应用</th></tr>
        <tr><td class="key">r：</td>
        <td class="desc">刷新</td></tr>
        <tr><td class="key">f：</td>
        <td class="desc">切换至全屏模式</td></tr>
        <tr><td class="key">u：</td>
        <td class="desc">隐藏/取消隐藏左侧模块</td></tr>
        <tr><td class="key">1:</td>
        <td class="desc">切换至扩展视图</td></tr>
        <tr><td class="key">2:</td>
        <td class="desc">切换至列表视图</td></tr>
        <tr><td class="key">/:</td>
        <td class="desc">将光标移动到搜索框</td></tr>
        <tr><td class="key">a:</td>
        <td class="desc">添加订阅</td></tr>
        <tr><td class="key">=:</td>
        <td class="desc">提高放大倍数</td></tr>
        <tr><td class="key">-:</td>
        <td class="desc">降低放大倍数</td></tr></tbody></table></td></tr>
        <tr><td class="help-section"><table><tbody><tr><th colspan="2">跳转</th></tr>
        <tr><td class="key">g 然后 h：</td>
        <td class="desc">转到主页</td></tr>
        <tr><td class="key">g 然后 a：</td>
        <td class="desc">转到所有条目</td></tr>
        <tr><td class="key">g 然后 s：</td>
        <td class="desc">转到加星标条目</td></tr>
        <tr><td class="key">g 然后 u：</td>
        <td class="desc">打开订阅选择器</td></tr>
        <tr><td class="key">g 然后 t：</td>
        <td class="desc">打开标签选择器</td></tr>
        <tr><td class="key">g 然后 &lt;Shift&gt; + t：</td>
        <td class="desc">转到趋势页</td></tr>
        <tr><td class="key">g 然后 d：</td>
        <td class="desc">转到查找页</td></tr>
        <tr><td class="key">依次按 g 和 e：</td>
        <td class="desc">开始探索</td></tr>
        <tr><td class="key">依次按 g 和 p：</td>
        <td class="desc">转到热门条目</td></tr></tbody></table></td>
        <td class="help-section"><table><tbody><tr><th colspan="2">对条目采取行动</th></tr>
        <tr><td class="key">s：</td>
        <td class="desc">为条目加注星标</td></tr>
        <tr><td class="key">t：</td>
        <td class="desc">标记条目</td></tr>
        <tr><td class="key">e：</td>
        <td class="desc">通过电子邮件发送条目</td></tr>
        <tr><td class="key">&lt;Shift&gt; + s：</td>
        <td class="desc">共享条目</td></tr>
        <tr><td class="key">v：</td>
        <td class="desc">查看原始内容</td></tr>
        <tr><td class="key">或<enter>键：</enter></td>
        <td class="desc">展开/折叠条目（仅限列表）</td></tr>
        <tr><td class="key">m：</td>
        <td class="desc">将条目标为已读/未读</td></tr>
        <tr><td class="key">&lt;Shift&gt; + a：</td>
        <td class="desc">全部标为已读</td></tr>
        <tr><td class="key">&lt;Shift&gt; + t：</td>
        <td class="desc">打开“发送到”菜单</td></tr></tbody></table></td></tr></tbody></table>
        <div id="keyboard-help-tearoff-link-container"><span class="link keyboard-help-tearoff-link open-new-window-link">在新窗口中打开</span>
        -
        <span class="link keyboard-help-tearoff-link close-help-link">关闭</span>
        </div>
        </div>
        </div>''')
    div.append(content)
    div2.append(content)
    $('body').append(div)
    $('body').append(div2)

generateContentList = (entries) ->
    i = 0
    for item in entries
        dt = new Date(item.publishedDate)
        date = dt.toLocaleTimeString()

        link = item.link
        stitle = item.stitle
        title = item.title
        desc = item.contentSnippet

        i += 1
        a = (obj, args) ->
            obj.find(".collapsed").click -> showDetail(obj, args)
            obj.find("div.entry-icons").click (e) ->
                toggleStar(obj, args)
                e.stopPropagation()

            obj.find("div.entry-actions span:first").on "click", (e) -> toggleStar(obj, args)

            obj.find("div.entry-actions span.read-state").on "click", (e) ->
                $(this).toggleClass("read-state-not-kept-unread")
                $(this).toggleClass("read-state-kept-unread")
                obj.toggleClass("read")

        a(div, item)

        $("#entries").append(div)

errorHandler = (e) ->
    msg = ""
    switch  e.code
        when FileError.QUOTA_EXCEEDED_ERR
            msg = 'QUOTA_EXCEEDED_ERR'
            break
        when FileError.NOT_FOUND_ERR
            msg = 'NOT_FOUND_ERR'
            break
        when FileError.SECURITY_ERR
            msg = 'SECURITY_ERR'
            break
        when FileError.INVALID_MODIFICATION_ERR
            msg = 'INVALID_MODIFICATION_ERR'
            break
        when FileError.INVALID_STATE_ERR
            msg = 'INVALID_STATE_ERR'
            break
        else
            msg = 'Unknown Error'
            break
    alert msg

addFeed = () ->
    url = $("#quickadd").val()
    if url.indexOf("http://") != 0
        alert "invalid feed url"
        return
    if localStorage.getItem(url)
        # TODO: Use google style flash messages instead of alert
        alert "You have subscribed to #{url}"
        return

saveFavicon = (faviconUrl, domainName, cb) ->
    xhr = new XMLHttpRequest()
    xhr.open('GET', faviconUrl, true)
    xhr.responseType = 'blob'

    xhr.onerror = () ->
        cb("img/default.gif")

    xhr.onreadystatechange = (e) ->
        if this.readyState < 4
            $("#loading-area-container").removeClass("hidden")
        else
            $("#loading-area-container").addClass("hidden")

    xhr.onload = (e) ->
        $("#loading-area-container").addClass("hidden")
        if this.status != 200 or xhr.response.size == 0
            saveFavicon("/media/img/default.gif", domainName, cb)
        else
            fs.root.getFile domainName+".ico", {create: true}, (fileEntry) ->
                fileEntry.createWriter (fileWriter) ->
                    fileWriter.onwriteend = (e) ->
                        cb(fileEntry.toURL())
                    fileWriter.onerror = (e) ->
                        console.log('Write failed:' + e.toString())
                    fileWriter.write(xhr.response)
                , errorHandler
            , errorHandler
    xhr.send()

getJsonFeed = (url, cb) ->
    #jQuery.getFeed({
    #    url: url,
    #    success: (feed) ->
    #        alert(feed.title)
    #})
    $("#loading-area-container").removeClass("hidden")
    $.ajax
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=50&callback=?&q=' + encodeURIComponent(url),
        dataType: 'json',
        success: (data) ->
            feed = data.responseData.feed
            for item in feed.entries
                item.stitle = feed.title
            cb(feed)
        complete: () ->
            $("#loading-area-container").addClass("hidden")

generateFeed = (feed) ->
    li = $(sprintf('<li class="sub unselectable expanded unread">\n<div class="toggle sub-toggle toggle-d-2 hidden"></div>\n<a class="link" title="%s">\n <div style="background-image: url(%s); background-size:16px 16px" class="icon sub-icon icon-d-2 favicon">\n </div>\n <div class="name-text sub-name-text name-text-d-2 name sub-name name-d-2 name-unread">%s</div>\n <div class="unread-count sub-unread-count unread-count-d-2"></div>\n <div class="tree-item-action-container">\n <div class="action tree-item-action section-button section-menubutton goog-menu-button"></div>\n </div>\n </a>\n </li>', feed.feedUrl, feed.favicon, feed.title))
    li.find("a:first").click ->
      showContent(feed.feedUrl)
    return li

toggle = (obj) ->
    obj.toggleClass("collapsed")
    obj.toggleClass("expanded")

removeFeed = () ->
    localStorage.removeItem(currentFeedUrl)
    for feed in subscriptions
        if feed.feedUrl == currentFeedUrl
            subscriptions.splice(subscriptions.indexOf(feed), 1)
            localStorage.setItem("subscriptions", JSON.stringify(subscriptions))
            $("#sub-tree-item-0-main ul:first li a[title='#{currentFeedUrl}']").parent().remove()
            $("#stream-prefs-menu").click()
            return

# Auto fix height
auto_height = () ->
    $section = $('#scrollable-sections')
    $section.css height: $(window).height() - $section.offset().top - 10

    $viewer = $('#viewer-entries-container')
    $viewer.css height: $(window).height() - $viewer.offset().top - 10

do ($ = jQuery) ->
    # Event bindding for quick add
    $("#lhn-add-subscription").on 'click', toggleAddBox
    $('#quick-add-close').on 'click', toggleAddBox

    $("#add-feed").on 'click', addFeed
    $(".folder-toggle").click -> toggle($(this).parent())
    $("#lhn-selectors-minimize").click -> $("#lhn-selectors").toggleClass("section-minimized")
    $("#lhn-recommendations-minimize").click -> $("#lhn-recommendations").toggleClass("section-minimized")
    $("#lhn-subscriptions-minimize").click -> $("#lhn-subscriptions").toggleClass("section-minimized")

    # Setting menu event bindings
    $('#settings-button-container').on 'click', () -> $('#settings-button-menu').toggle()

    $('#quickadd').bind 'keypress', (e) ->
        code = if e.keyCode then e.keyCode else e.which
        console.log(code)
        if code == 13 then $("#add-feed").click()

    setInterval auto_height, 200

    # UI adjust
    $("div[role=button]").hover -> $(this).toggleClass("jfk-button-hover")
    $("div[role=listbox]").hover -> $(this).toggleClass("goog-flat-menu-button-hover")
    $("#entries-up").on "click", () -> $("#current-entry").prev().find(".collapsed").click()
    $("#entries-down").on "click", () -> $("#current-entry").next().find(".collapsed").click()

    # html5 file system
    window.requestFileSystem  = window.requestFileSystem || window.webkitRequestFileSystem
    if window.requestFileSystem
        window.requestFileSystem window.TEMPORARY, 100*1024*1024, (filesystem) ->
            fs = filesystem
        , errorHandler

    # keyboard shortcut
    $("body").bind 'keypress', (e) ->
        code = if e.keyCode then e.keyCode else e.which
        #J 下一篇
        if code == 106 then $("#current-entry").next().find(".collapsed").click()
        #K 上一篇
        if code == 107 then $("#current-entry").prev().find(".collapsed").click()
        #{ENTER} 收起
        if code == 13 
          $("#current-entry").removeClass("expanded")
          $("#current-entry").find(".entry-container").remove()
          $("#current-entry").find(".entry-actions").remove()
        #F 全屏
        if code == 102
            $("body").toggleClass("fullscreen")
            $("body").toggleClass("lhn-hidden")
        #帮助
        if code == 63 then toggleShortcutMap()

