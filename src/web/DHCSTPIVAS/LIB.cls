Class web.DHCSTPIVAS.LIB Extends %RegisteredObject
{

/// css: 为none时, 不加载css
ClassMethod Load(css = "")
{
    w !, "<!-- 住院配液中心通用 ST-->"
    if (css '= "none"){
        d ..LoadCss("../scripts/pharmacy/common/css/dhcpha.hisui.css")
        d ..LoadCss("../scripts/pharmacy/pivas/css/ui.css")
    }
    d ..LoadJs("../scripts/pha/plugins/handlebars/handlebars-v4.7.6.js")
    d ..LoadJs("../scripts/pha/plugins/qrcode/qrcode.min.js")
    d ..LoadJs("../scripts/pharmacy/common/js/dhcpha.hisui.extend.js")
    d ..LoadJs("../scripts/pharmacy/common/js/dhcpha.hisui.com.js")
    d ..LoadJs("../scripts/pharmacy/common/js/dhcpha.export.js")
    d ..LoadJs("../scripts/pharmacy/pivas/common.js")
    d ..LoadJs("../scripts/pharmacy/pivas/print.js")
    w !, "<!-- 住院配液中心通用 ED-->"
}

/// Description: 加载Js文件标签
ClassMethod LoadJs(src, charSet = "")
{
    if (charSet '= ""){
        s charSet = "charset=" _ charSet
    }
    w !, "<script type=""text/javascript"" src=""" _ src _ """ " _ charSet _ "></script>"
}

/// Description: 加载Css文件标签
ClassMethod LoadCss(href)
{
    w !, "<link rel=""stylesheet"" type=""text/css"" href=""" _ href _ """ />"
}

}
