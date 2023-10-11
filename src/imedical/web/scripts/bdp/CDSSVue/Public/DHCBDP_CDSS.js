document.write('<script type="text/javascript" src="../scripts/bdp/CDSSVue/Public/DHCBDPTriggerCDSS.js"></script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/CDSS/style/css/cdssStyle.css"/>');
var cdssWidth=340
//MWToken20230213sxw
var CDSSToken = ""
if("undefined" != typeof websys_getMWToken){
    CDSSToken = websys_getMWToken();
}
//插入医为百科的浏览弹框
$('body').append('<div id="encyclopedia_win" style="overflow:hidden"><div id="encyclopedia_lay"></div></div>');
$("#encyclopedia_win").window({
    //iconCls:'icon-w-add',
    resizable: true,
    minimizable: false,
    title: 'iMedical-CDSS 东华医为临床辅助决策支持',
    width: $(window).width() * 9.5 / 10,
    height: $(window).height() * 9.5 / 10,
    modal: false,
    isTopZindex: true
});
$('#encyclopedia_lay').css({
    width: '99%',
    height: '99%',
    padding: '5px',
    position: 'relative'
})
$('#encyclopedia_lay').append(
    '<div id="div-img-s" style="width:100%;height:8%;text-align:center"><img src="../scripts/bdp/CDSSVue/imgs/noselect-warn.png" alt="没有数据哦，重新输入试试吧" style=""/></div><form id="form1" action="../csp/dhc.bdp.cdss.literature.csp" target="target1" method="post"><input name="fileName" type="hidden" value="" /></form><iframe id="encyclopedia_iframe" frameborder="0" src="" name="target1" width="100%" height="99%" ></iframe>'
)
$("#encyclopedia_win").window('close');
openFeedBack = function () {
    $("#encyclopedia_win").window({
        resizable: true,
        width: 800,
        left: ($(window).width() - 800) / 2,
        height: $(window).height() * 7.5 / 10,
    });
    var url = '../csp/dhc.bdp.cdss.feedback.csp?MWToken='+CDSSToken
    $('#div-img-s').hide();
    $("#encyclopedia_win").window('open');
    $('#encyclopedia_iframe').css({ 'display': 'block' })
    $('#encyclopedia_iframe').attr("src", url);
}
goBaiKe = function (url) {
    if ('undefined'!==typeof websys_getMWToken){
        url += "&MWToken="+websys_getMWToken() 
    }
    $("#encyclopedia_win").window({
        resizable: true,
        width: $(window).width() * 9.5 / 10,
        left: $(window).width() * 0.5 / 10 / 2
    })
    $('#div-img-s').hide();
    $("#encyclopedia_win").window('open');
    $('#encyclopedia_iframe').css({ 'display': 'block' })
    $('#encyclopedia_iframe').attr("src", url);
}
goLite= function (LiteName) {
     /*var MInterface = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","CDSSDataServerIP")
    MInterface = MInterface+"/web";*/
    var MInterface = ""
    if (getWebsysCDSSConfig){
        var CDSSClientList = getWebsysCDSSConfig()
        for(var i =0;i<CDSSClientList.length;i++){
          if (CDSSClientList[i].type==='mediway'){
            MInterface  = CDSSClientList[i].serverpath;
            break
          }
        }
      }
    var filepath =MInterface+"/web/scripts/bdp/CDSS/Doc/"+LiteName.fileName;
    window.open(filepath)
}
goRatingScale = function (url) {
    if ('undefined'!==typeof websys_getMWToken){
        url += "&MWToken="+websys_getMWToken() 
    }
    $("#encyclopedia_win").window({
        resizable: true,
        width: $(window).width() * 9.5 / 10,
        left: $(window).width() * 0.5 / 10 / 2
    })
    $('#div-img-s').hide();
    $("#encyclopedia_win").window('open');
    $('#encyclopedia_iframe').css({ 'display': 'block' })
    $('#encyclopedia_iframe').attr("src", url);
}
$('body').append('<div id="cdssicon" onmousedown="_cdssdown(this)" onmousemove="_cdssmove(this)" onmouseup="_cdssup(this)"><img id="moveImg" onmousedown="_cdssstopDefault()" src="../scripts/bdp/CDSSVue/imgs/move.png" style=""/><div id="cdss_warn_num"></div></div><div id="cdssContainer"><iframe ref="iframe" align="center" id="htmlContainer" src="../scripts/bdp/CDSSVue/dist/index.html"  frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no"></iframe></div>')
$('#cdssicon').css({
    position: 'absolute',
    bottom: '30px',
    right: '10px',
    height: '50px',
    width: '50px',
    'z-index': '9002',
    'background-color': 'rgba(255,255,255,0)',
    cursor:'pointer'
});
$("#cdss_warn_num").css({
    position: 'absolute',
    'background-color': 'red',
    'border-radius': '50%',
    'font-size': '8px',
    'font-weight': 900,
    height: '14px',
    width: '14px',
    color: 'white',
    top: '2px',
    right:'2px',
    'line-height': '14px',
    'text-align': 'center',
    display:'none'
})
$('#cdssContainer').css({
    position: 'absolute',
    bottom: '30px',
    right: '10px',
    height: '0px',
    width: '0px',
    'z-index': '9002',
    'background-color': 'rgba(255,255,255,0)'
});
$('#htmlContainer').css({
    width: '100%',
    height: '100%',
    'background-color': 'rgba(255,255,255,0)'
})
DriverCDSS = function (PatientInfo) {
    var Info = { 'action': 'INITIALIZE_PATIENT_INFORMATION', 'data': PatientInfo }
    document.getElementById("htmlContainer").contentWindow.postMessage(Info, '*')
}
showcdss = function () {
    $("#cdssContainer").css('width', cdssWidth+'px')
    $("#cdssContainer").css('height', '75%')
}
changeCdssWarnNum = function(num){
    if (num>0){
        document.getElementById("cdss_warn_num").innerText=num
        document.getElementById("cdss_warn_num").style.display='block'
    }else{
        document.getElementById("cdss_warn_num").style.display='none'
    }
}
hiddenCDSS = function () {
    $("#cdssContainer").css('width', '0px')
    $("#cdssContainer").css('height', '0px')
}
enlargeMenu = function () {
    //判断距离屏幕距离
    cdssWidth=400
    if (document.getElementById("cdssContainer").offsetLeft<60){
        document.getElementById('cdssContainer').style.right = document.body.clientWidth - cdssWidth +'px'
    }
    $("#cdssContainer").css('width', cdssWidth+'px')
    $("#cdssContainer").css('height', '75%')
}
shrinkMenu = function () {
    cdssWidth=340
    $("#cdssContainer").css('width', cdssWidth+'px')
    $("#cdssContainer").css('height', '75%')
}
WriteToEmr  = function(data){
    try{
        getWebsysCDSS('mediway').MonitorWriteData(data)
    }catch(e){
        alert("请手动切换到病历界面再进行写回操作")
    }
}
OpenOrderToHis = function (Type,str) {
    var OrderTimeType ="临时医嘱"
    if((window.frames["TRAK_main"]["idhc_side_oe_oerecord"] != undefined)&&(window.frames["TRAK_main"]["idhc_side_oe_oerecord"].document.getElementById("HiddenOrderPrior").value =="LongOrderPrior"))
    {
	OrderTimeType ="长期医嘱"
    }
    if (Type == 'OrderName')
    {
        var DataInfo = "web.CDSS.IMP.ContrastDict[A]GetMatchCodeOrICD[A]" + str; //获取对照的his编码
        str = CDSSMakeServerCall(DataInfo);
    }
    if ((str.indexOf("[")>0)&&(str.indexOf("]")>0))
    {
        var PartDr=str.slice(str.indexOf("[")+1,str.indexOf("]"))
        str = str.slice(0,str.indexOf("["))
        CopyDataForCDSS('ORDER', [str + "!!" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + OrderTimeType + String.fromCharCode(1) + "^^^^^^^^^^" + String.fromCharCode(1) + "^^"+PartDr+"^^^!!!Order"])
    	return
    } 
    CopyDataForCDSS('ORDER', [str + "!!" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + OrderTimeType + String.fromCharCode(1) + "^^^^^^^^^^" + String.fromCharCode(1) + "^^^^^!!!Order"])
}
openCMOrder = function (OrderList) {
    var OrderListStr=[]
	for (var i=0;i<OrderList.length;i++)
	{
		var str=OrderList[i].MatchCode
	    OrderListStr.push(str + "!!" + OrderList[i].Dosage + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + String.fromCharCode(1) + "^" +String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + "临时医嘱" + String.fromCharCode(1) + "^^^^^^^^^^" + String.fromCharCode(1) + "^^^^^!!!Order")
	}
    CopyDataForCDSS("CMORDER",OrderListStr)
}
OpenBatchOrder = function(OrderList){
    var OrderTimeType ="临时医嘱"
    if((window.frames["TRAK_main"]["idhc_side_oe_oerecord"] != undefined)&&(window.frames["TRAK_main"]["idhc_side_oe_oerecord"].document.getElementById("HiddenOrderPrior").value =="LongOrderPrior"))
    {
	OrderTimeType ="长期医嘱"
    }
	var OrderListStr=[]
	for (var i=0;i<OrderList.length;i++)
	{
		var str=OrderList[i].ItemCode
		if ((str.indexOf("[")>0)&&(str.indexOf("]")>0))
    	{
        	var PartDr=str.slice(str.indexOf("[")+1,str.indexOf("]"))
        	str = str.slice(0,str.indexOf("["))
        	OrderListStr.push(str + "!!" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + OrderTimeType + String.fromCharCode(1) + "^^^^^^^^^^" + String.fromCharCode(1) + "^^"+PartDr+"^^^!!!Order")
    	}else{
	    	OrderListStr.push(str + "!!" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + String.fromCharCode(1) + String.fromCharCode(1) + "^" + OrderTimeType + String.fromCharCode(1) + "^^^^^^^^^^" + String.fromCharCode(1) + "^^^^^!!!Order")
	    }
    	
	}
	console.log(OrderListStr)
	CopyDataForCDSS("ORDER",OrderListStr)
}
OpenDiagToHis = function (data) {
    //开立诊断
    var DataInfo = "web.CDSS.IMP.ContrastDict[A]GetMatchCodeOrICD[A]" + data;//获取对照的his编码
    var str = CDSSMakeServerCall(DataInfo);
    CopyDataForCDSS('DIAG', [{ 'ICDCode': str, 'ICDRowid': '', 'Note': '', 'CMFlag': 'N' }])//调用医生站开立前台方法
}
minimize = function () {
    $("#cdssContainer").css('width', '7px')
    $("#cdssContainer").css('height', '50px')
    $("#cdssContainer").css('cursor', '')
    $("#htmlContainer").css('display', 'none')
    $("#cdssContainer").css('background-color', 'rgb(62, 85, 252)')
    $("#cdssContainer").css('border-radius', '8px')
    document.getElementById('cdssContainer').ondblclick = function () {
        $("#cdssContainer").css('width', '50px')
        $("#cdssContainer").css('background-color', '#fff')
        $("#htmlContainer").css("display", '')
        $("#moveImg").css('display', 'none')
        return false;
    };
}
/*暂不使用
movecdss = function () {
    $("#cdssContainer").css('width', '50px')
    $("#cdssContainer").css('height', '50px')
    $("#htmlContainer").css('display', 'none')
    $("#moveImg").css('display', '')
    $("#cdssContainer").css('cursor', 'move')
    document.getElementById('cdssContainer').ondblclick = function () {
        //_drag_init(this);
        $("#cdssContainer").css('width', '50px')
        $("#cdssContainer").css('height', '50px')
        $("#cdssContainer").css('background-color', '#fff')
        $("#htmlContainer").css("display", '')
        $("#moveImg").css('display', 'none')
        return false;
    };
}*/
/***************************************全文检索*************************************************** */
/***************************************全文检索*************************************************** */

goTerm = function (MKBTBCode, MKBTBDesc, TermID, ProId, DetId) {
    $('#div-img-ss').hide();
    $('#encyclopedia_newiframe').css({ 'display': 'block' })

    var url = "../csp/dhc.bdp.cdss.cdssencyclopediav2.csp?base=&id=" + TermID + "&proid=" + ProId+"&MWToken="+CDSSToken;
    $('#encyclopedia_newiframe').attr("src", url);
}

//搜索功能
SearchFunLibNew = function (searchText) {
    $("#encyDesc_win").val(searchText);
    $("#encyclopedia_newwin").window('open');
    $('#encyDesc_div .searchbox-text').val(searchText)
    loadNewEncyData()
    showFirst(searchText);
}
//插入医为百科的浏览弹框
$('body').append('<div id="encyclopedia_newwin" style="overflow:hidden"><div id="encyclopedia_newlay"></div></div>');
$("#encyclopedia_newwin").window({
    //iconCls:'icon-w-add',
    resizable: true,
    minimizable: false,
    title: '知识库浏览',
    width: $(window).width() * 9.9 / 10,
    height: $(window).height() * 9.9 / 10,
    modal: false,
    isTopZindex: true

});
$('#encyclopedia_newlay').css({
    width: '99%',
    height: '99%',
    padding: '5px',
    position: 'relative'
})

function CDSSMakeServerCall (DataInfo){
    var returnInfo ="";
    var str = DataInfo.replace(/\"/g, '""')
    returnInfo = tkMakeServerCall("web.CDSS.Public.MethodForWebservice","CallMethod",str)
    return returnInfo
}
var ShowUpToDate = CDSSMakeServerCall("web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]ShowUpToDate")
if(ShowUpToDate=="Y"){
    var UpToDateURL = CDSSMakeServerCall("web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]UpToDateURL")

    $('#encyclopedia_newlay').append(//检索2.0更改
        ' <div id="viewSourceTab" class="hisui-tabs tabs-gray"  data-options="fit:true">'
            +'<div title="医为百科" id="docTab" style=""> '
                + '<div id=encyclopedia_west" style="position:absolute;width:' + document.body.clientWidth * 9.9 / 40 + 'px;height:100%;float:left;border:1px solid #b2bec3;margin-right:4px;padding:5px">'
                    + '<div id="ency_lay_north" style="width:100%;height:35px"></div>'
                    + '<div id="ency_lay_center" style="width:100%;height:'+($(window).height() * 9 / 10)+'px;overflow:scroll"></div>'
                   /* + '<div id="ency_lay_south" style="width:100%;height:35px;position:absolute;bottom:10px">'
                        +'<div id="footer" style="text-align:center"></div>'
                    + '</div>'*/
                + '</div>'
                + '<div id=encyclopedia_center" style="width:' + document.body.clientWidth * 9.9 *2.9 / 40 + 'px;height:100%;border:1px solid #b2bec3;float:right">'
                    +'<div id="div-img-ss" style="width:100%;height:100%;text-align:center;"><img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" alt="没有数据哦，重新输入试试吧" style=""/></div><iframe id="encyclopedia_newiframe" frameborder="0" src="" width="100%" height="99%" ></iframe>'
                + '</div>'
            +'</div>'
            +'<div title="UpToDate临床顾问" id="upTab" style=""> '
            +'<iframe id="upiframe" frameborder="0" src="'+UpToDateURL+'" width="100%" height="2000px" style="overflow:hidden"></iframe>'
            +'</div>'
        +'</div>'
    )
    $('#viewSourceTab').tabs()
}else{
    $('#encyclopedia_newlay').append(
         '<div id=encyclopedia_west" style="position:absolute;width:' + parseInt(document.body.clientWidth) * 9.9 / 40 + 'px;height:100%;float:left;border:1px solid #b2bec3;margin-right:4px;padding:5px">'
        + '<div id="ency_lay_north" style="width:100%;height:35px"></div>'
        + '<div id="ency_lay_center" style="width:100%;margin-left:10px;height:'+($(window).height() * 9 / 10)+'px;overflow:scroll"></div>'
       /* + '<div id="ency_lay_south" style="width:100%;height:35px;position:absolute;bottom:10px">'
            +'<div id="footer" style="text-align:center"></div>'
        + '</div>'*/
        + '</div>'
        + '<div id=encyclopedia_center" style="width:' + document.body.clientWidth * 9.9 *2.9 / 40 + 'px;height:100%;border:1px solid #b2bec3;float:right">'
            +'<div id="div-img-ss" style="width:100%;height:100%;text-align:center;"><img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" alt="没有数据哦，重新输入试试吧" style=""/></div><iframe id="encyclopedia_newiframe" frameborder="0" src="" width="100%" height="99%" ></iframe>'
        + '</div>'
    )    
}
$('#ency_lay_north').append(
    '<div id="encyDesc_div" style="width:99%;height:30px;text-align:center;margin-top:5px;">' +
    '<input style="width:315px" placeholder="百科" id="encyDesc_win" />' +
    '</div>'
);
$('#encyDesc_win').searchbox({
});
$('#encyDesc_div .searchbox-text').attr('placeholder', '百科')
$('#encyDesc_div .searchbox-button').click(function () {
    loadNewEncyData()
    showFirst($('#encyDesc_div .searchbox-text').val());
})
//搜索回车事件
$('#encyDesc_div .searchbox-text').keyup(function (event) {
    if (event.keyCode == 13) {
        loadNewEncyData()
        showFirst($('#encyDesc_div .searchbox-text').val());
    }
});

$("#encyclopedia_newwin").window('close');//关闭window

function loadNewEncyData(){
        $('#ency_lay_center').html('')
        var DataInfo = "web.CDSS.Config.ALLDictIndex[A]GetIndexList[A]" + $('#encyDesc_div .searchbox-text').val() + "[A]百科" ;
        var data = CDSSMakeServerCall(DataInfo);
        data = eval('(' + data + ')');
        for(var i = 0; i<data.rows.length; i++){
            var text = data.rows[i].DictDesc
            text = text.replace(new RegExp($('#encyDesc_div .searchbox-text').val(),'g'),"<font color=red>"+$('#encyDesc_div .searchbox-text').val()+"</font>")
            $('#ency_lay_center').append(
               '<div class="search-content" style="margin-left:10px;width:93%;	border-bottom:1px dashed #70a1ff;padding-bottom:10px;">'+
                    '<div class="search-desc" style="width:80%;display: inline-block;font-size: 18px;margin-top:10px;font-size: 18px;">'+
                    '<a style="cursor: pointer;" onclick=goTerm("","","'+data.rows[i].CDSSDictDR+'","","")>'+text+'<font size="4" color="#3CBBAA">【'+data.rows[i].CDSSDictDesc+'】</font></a></div>'+
                '</div>'
            )
        }
    
}

/**
 * 搜索完毕，默认展示匹配项
 */
showFirst = function (diseasename) {

    /*var DescInfo = "web.CDSS.CMKB.WikiCMKBContrast[A]getWikiName[A]" + diseasename;
    var desc = CDSSMakeServerCall(DescInfo);
    if (desc.indexOf("\r\n") > -1) {
        desc = desc.replace(/\s+/g, "").replace(/<\/?.+?>/g, "").replace(/[\r\n]/g, "");
    }
    var termdr = ""
    if (desc != "") {
        diseasename = desc;
    }*/

    var DataInfo = "web.CDSS.CMKB.Term[A]getTermIDByDesc[A]疾病[A]" + diseasename;
    termdr = CDSSMakeServerCall(DataInfo);
    if (termdr == "") {
        var DataInfo = "web.CDSS.CMKB.Term[A]getTermIDByDesc[A]检查[A]" + diseasename;
        termdr = CDSSMakeServerCall(DataInfo);
        if (termdr == "") {
            var DataInfo = "web.CDSS.CMKB.Term[A]getTermIDByDesc[A]检验[A]" + diseasename;
            termdr = CDSSMakeServerCall(DataInfo);
        }
    }


    if (termdr) {
        $('#div-img-ss').hide();
        $('#encyclopedia_newiframe').css({ 'display': 'block' })

        var url = "../csp/dhc.bdp.cdss.cdssencyclopediav2.csp?base=&id=" + termdr + "&proid="+"&MWToken="+CDSSToken;
        $('#encyclopedia_newiframe').attr("src", url);
    }

}
/*CDSS图标拖拽 -暂不使用*/
/*
var selected = null, // Object of the element to be moved
    x_pos = 0, y_pos = 0, // Stores x & y coordinates of the mouse pointer
    x_elem = 0, y_elem = 0; // Stores top, left values (edge) of the element

// Will be called when user starts dragging an element
function _drag_init(elem) {
    // Store the object of the element which needs to be moved
    selected = elem;
    x_elem = x_pos - selected.offsetLeft;
    y_elem = y_pos - selected.offsetTop;
}

// Will be called when user dragging an element
function _move_elem(e) {
    x_pos = document.all ? window.event.clientX : e.pageX;
    y_pos = document.all ? window.event.clientY : e.pageY;
    if (selected !== null) {
        selected.style.right = (window.document.body.offsetWidth - (x_pos - x_elem) - 50) + 'px';
        selected.style.bottom = (window.document.body.offsetHeight - (y_pos - y_elem) - 50) + 'px';
    }
}
// Destroy the object when we are done
function _destroy() {
    selected = null;
}

// Bind the functions...
document.getElementById('cdssContainer').onmousedown = function () {
    _drag_init(this);
    return false;
};
document.getElementById('cdssContainer').onmousemove = _move_elem;
document.getElementById('cdssContainer').onmouseup = _destroy;
//
*/
//百科、评估表、文献窗口自适应分辨率
$(window).resize(function(){
    if ($("#encyclopedia_win").parent("div").css('display') == "block"){
        var target = this;
        if (target.resizeFlag) {
            clearTimeout(target.resizeFlag);
        }
        
        target.resizeFlag = setTimeout(function() {
	        
            $("#encyclopedia_win").window({
                width: $(window).width() * 9.5 / 10,
                height: $(window).height() * 9.5 / 10,
                left: $(window).width() * 0.5/10/2
            });
            target.resizeFlag = null;
        }, 100);
    }
})
window.DriverCDSS = DriverCDSS
_cdssopenMove = false; 
function cdssDisplay() { 
    document.getElementById("htmlContainer").contentWindow.vm.$store.commit("showCDSS")
} 
function _cdssstopDefault(e) { 
    e = e || event; 
    if (e && e.preventDefault) { 
        e.preventDefault(); 
    } else { 
        window.event.returnValue = false; return false; 
    } 
} 
function _cdssdown(_this) { 
    var e = e || event; _cdssstopDefault(e);
    _this.qopenMove = true; 
    _this.qisMove = false; 
    _this.qstX = e.clientX; 
    _this.qstY = e.clientY; 
    _this.qstR = parseInt(_this.style.right); 
    _this.qstB = parseInt(_this.style.bottom); 
} 
function _cdssup(_this) { 
    var e = e || event; _cdssstopDefault(e); 
    _this.qopenMove = false; 
    _this.qstX = ""; 
    _this.qstY = ""; 
    _this.qisMove ? "" : cdssDisplay(); 
    _cdssPanelMove()
} 
function _cdssmove(_this) { 
    var e = e || event; _cdssstopDefault(e); 
    if (_this.qopenMove) { 
        _this.qisMove ? "" : _this.qisMove = true; 
        var _qmoveX = e.clientX - _this.qstX; 
        var _qmoveY = e.clientY - _this.qstY; 
        var _qright = _this.qstR - _qmoveX; 
        var _qbottom = _this.qstB - _qmoveY;
        _this.style.right = _qright + "px"; 
        _this.style.bottom = _qbottom + "px"; 
    } 
} 
function _cdssPanelMove(){
    //判断距离是否足够显示CDSS
    if (document.getElementById('cdssicon').offsetLeft<cdssWidth){
        document.getElementById('cdssContainer').style.right = document.body.clientWidth - cdssWidth +'px'
    }else{
        document.getElementById('cdssContainer').style.right=document.getElementById('cdssicon').style.right
    }
    if (document.getElementById('cdssicon').offsetTop<document.body.clientHeight*0.75){
        document.getElementById('cdssContainer').style.bottom = document.body.clientHeight*0.25 +'px'
    }else{
        document.getElementById('cdssContainer').style.bottom=document.getElementById('cdssicon').style.bottom
    }
    
}