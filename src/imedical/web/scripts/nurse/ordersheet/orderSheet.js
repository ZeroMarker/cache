var global = {
    userID: session['LOGON.USERID'],
    locID: session['LOGON.CTLOCID'],
    hospID: session['LOGON.HOSPID'],
    langid: session['SYS.LANGID'],
    iframeWidth: 70,
    currPage: 0,    //��ǰҳ
    totalPages: 0,  //��ҳ��
    arrangeFlag: 0, //�Ƿ�����
    sheetType: "L", //Ĭ����ʾ����ҽ��
    sheetData: {}   //��̨��ȡ������
}

$.parser.onComplete = function (context) {
    if (!!context) return;
    init();
}

/// ����iframe�����,���30��iframe �������̫��iframe��ɵ�����
var objectPoolFactory = function (createObjFn) {
    var objectPool = [];
    return {
        create: function () {
            var obj;
            if (objectPool.length > 30) {
                var firstObject = objectPool.shift()
                destroyIframe(firstObject.id)
            }
            var obj = createObjFn.apply(this, arguments)
            return obj
        },
        recover: function (obj) {
            objectPool.push(obj);
        },
        remove: function () {
            objectPool = [];
        }
    }
}

function destroyIframe(iframeID){ 
    var iframe = document.getElementById(iframeID);
    //��iframeָ��հ�ҳ�棬���������ͷŴ󲿷��ڴ档 
    iframe.src = 'about:blank'; 
    try{ 
        iframe.contentWindow.document.write(''); 
        iframe.contentWindow.document.clear(); 
    }catch(e){}
    //��iframe��ҳ���Ƴ� 
    iframe.parentNode.removeChild(iframe); 
}

var iframeFactory = objectPoolFactory(function () {
    var iframe = document.createElement("iframe");
    iframe.onload = function () {
        iframe.onload = null;
        iframeFactory.recover(iframe);
        return iframe;
    }
    return iframe
})

//��ʼ��
function init() {
    var frm = dhcsys_getmenuform();
    if (frm) {
        episodeID = frm.EpisodeID.value;
    }
    initHandler.initEvent();

}

// �л�����
function switchPatient(rowData) {
	$("#locsChange").html("")
    $('#pageView').html("")
    global.arrangeFlag = 0
    $('#arrangeOrderBtn .menu-text').html($g("����ҽ��"))
    episodeID = rowData["EpisodeID"]
    setEprMenuForm(rowData["EpisodeID"], rowData["PatientID"], rowData["mradm"], "");
    loadChart()
}
//����ҽ����
function loadChart() {
    chartHandler.init()
    loading()
    $cm({
        ClassName: "Nur.NIS.Service.OrderSheet.Sheet",
        MethodName: "getOrders",
        Type: global.sheetType,
        EpisodeID: episodeID,
        UserID: global.userID,
        LocID: global.locID,
        ArrangeFlag: global.arrangeFlag,
        Langid: global.langid,
        ResultSetType: "array"
    }, function (sheet) {
        if (sheet == "-1" || sheet.totalPage == 0) {
            disLoad()
            global.sheetData = []
            global.totalPages = 0
            $.messager.popover({ msg: '������ҽ��', type: 'error' });
            return;
        }
        global.sheetData = sheet
        global.totalPages = sheet.totalPage
        initHandler.initLocs();
        initHandler.initPageBox();
        if (global.sheetData.GeneralConfig.IfDefFrontPageFlag=="Y")
        {
	        pageHandler.jumpPage("1") // Ĭ����ʾ���һҳ
	    }else{
        	pageHandler.jumpPage(global.totalPages) // Ĭ����ʾ���һҳ
	    }
    });

}

//��ʼ��һЩ����
var initHandler = {
    //��ʼ���¼�
    initEvent: function () {
	    if(!!window.ActiveXObject || "ActiveXObject" in window){
		    $("#viewZoomInBtn").hide()
		    $("#viewZoomOutBtn").hide()
    	}
        $('#firstPageBtn').bind('click', pageHandler.firstPage);
        $('#prePageBtn').bind('click', pageHandler.prePage);
        $('#nextPageBtn').bind('click', pageHandler.nextPage);
        $('#lastPageBtn').bind('click', pageHandler.lastPage);
        $('#printCurrPageBtn').bind('click',function(){printHandler.print(global.currPage)});
        $('#printSelectPageBtn').bind('click',function(){
	        if (global.totalPages > 0)
	        {
	         $("#selectPageWin").window("open") 
	        }
	    });
        $('#viewRefreshBtn').bind('click', hrefRefresh);
        $("#viewZoomInBtn").bind('click', viewHandler.zoomIn)
        $("#viewZoomOutBtn").bind('click', viewHandler.zoomOut)
        $('#printOutAllPageXuBtn').bind('click', printHandler.printAllXu);
        $('#printOutAllPageBtn').bind('click', printHandler.printAll);
        /*
        $('#changeTypeBtn').bind('click', changeTypeBtnClick);
        $('#nurseSheetBtn').bind('click', nurseSheetBtnClick);
        */
        $('#deletePrintRecBtn').bind('click', printHandler.deletePrintRecord);
        $('#printSelectedRowsBtn').bind('click', printHandler.printRow);
        $('#arrangeOrderBtn').bind('click', arrangeOrderBtnClick);
        $("[name='pageInput']").keydown(function (e) {
            if (e.keyCode == "13") {
                pageHandler.jumpPage($(this).val())
            }
        })
        $("#selectPageWin").window({
	        width: 300,
	        height: 130,
	        modal: true,
	        closed: true,
	        collapsible: false,
	        minimizable: false,
	        maximizable: false,
	        closable: true,
	        title: $g('ҳ��ѡ��'),
	        iconCls: 'icon-w-paper'
    	})
    	$("#selectPagePrintBtn").bind("click",function(){
	    	var startPage = $('#startPageNum').val()
	    	var endPage = $('#endPageNum').val()
	    	if (startPage == "" || endPage == "")
	    	{
		    	$.messager.popover({ msg: 'ҳ�벻��Ϊ��', type: 'error' });
		    	return
		    }
	        printHandler.printSelect(startPage, endPage)
	        $("#selectPageWin").window("close")
	    })
	    
	    /*���ص���ѡ��ҳǩ*/
	    var sheetsJson = $cm({
		    ClassName:"Nur.NIS.Service.OrderSheet.Sheet",
		    MethodName:"getSheets",
		    HospID: global.hospID,
		    CtlocID: global.locID
		},false)
		$.each(sheetsJson,function(index,single){
			if (index == 0)
			{
				global.sheetType = single.mark
			}
			$("#sheets").append('<a title="' + single.name + '" type="' + single.mark + '" href="javascript:void(0)" class="hisui-tooltip buttonStyle ' + ((index == 0) ? "clicked" : "") + '" data-options="position:bottom"  onclick="changeTypeBtnClick(this)" >' + $g(single.name) + '</a>')
		})
		/*
	    var defaultSheetType = $m({
		    ClassName:"Nur.NIS.Service.OrderSheet.Sheet",
		    MethodName:"getDefaultSheetType",
		    HospID: global.hospID
		},false)
		global.sheetType = defaultSheetType
		if (global.sheetType == "L") {
        	$('#changeTypeBtn').html($g("��ʱҽ����"));
	    } else {
	        $('#changeTypeBtn').html($g("����ҽ����"));
	    }
	    var ifShowNurOrdSheet = $m({
		    ClassName:"Nur.NIS.Service.OrderSheet.Sheet",
		    MethodName:"ifShowNurOrdSheet",
		    HospID: global.hospID
		},false)
		if (ifShowNurOrdSheet=="N")
		{
			$('#nurseSheetBtn').hide()
		}
		*/
		
    },
    //��ʼ�������б�
    initLocs: function () {
        $("#locsChange").html("")
        var locs = global.sheetData.locs;
        var pageLink = global.sheetData.pageLink;
        var lastDesc = Object.keys(pageLink).pop()
        for (var index = 0, length = locs.length; index < length; index++) {
            var desc = locs[index], pageNo = -1
            if (!!pageLink[desc]) { pageNo = pageLink[desc] }
            $("#locsChange").append('<a title="' + desc + '" href="javascript:void(0)" class="hisui-tooltip buttonStyle ' + ((lastDesc == desc) ? "clicked" : "") + '" data-options="position:bottom" onclick="pageHandler.jumpPage(' + pageNo + ',this)" >' + desc + '</a>')
        }
    },
    //����ҳ����ʾ
    initPageBox: function () {
        $("#totalPageSpan").html($g("��") + global.totalPages + $g("ҳ"));
        $("#pageInput").triggerbox('setValue', global.currPage);
        $('#startPageNum').numberbox({
                min: 1,
                value: 1
        });
        $('#startPageNum').keyup(function(){
	        var num = $('#startPageNum').val()
	        if (parseInt(num)<=0 || parseInt(num)>global.totalPages)
	        {
		        $('#startPageNum').val(1)
		    }
	    })
        $('#endPageNum').numberbox({
                min: 1,
                value: global.totalPages
        });    
        $('#endPageNum').keyup(function(){
	        var num = $('#endPageNum').val()
	        if (parseInt(num)<=0 || parseInt(num)>global.totalPages)
	        {
		        $('#endPageNum').val(global.totalPages)
		    }
	    }) 
    }
}

// �л� ����ҽ��/��ʱҽ��
function changeTypeBtnClick(target) {
	global.sheetType = $(target).attr("type")
    $('#sheets a[class*="clicked"]').removeClass("clicked")
    $(target).addClass("clicked")
    global.arrangeFlag = 0
    $('#arrangeOrderBtn .menu-text').html($g("����ҽ��"))
    if (global.sheetType.indexOf("L")>-1)
    {
		$('#arrangeOrderBtn').show()
	}else{
		$('#arrangeOrderBtn').hide()
	}
    loadChart();
}

// ������
function nurseSheetBtnClick()
{
	$('#changeTypeBtn').html($g("����ҽ����"));
	global.sheetType = "N";
	global.arrangeFlag = 0
    $('#arrangeOrderBtn .menu-text').html($g("����ҽ��"))
    $("#arrangeOrderBtn").toggle();
    loadChart();
}

//���¼���
function hrefRefresh() {
    var srcUrl = "./nur.svg.ordersheet.csp?EpisodeID=" + episodeID + "&SheetType=" + global.sheetType + "&page=" + global.currPage
        + "&webIP=" + global.webIP + "&userID=" + global.userID + "&locID=" + global.locID + "&v=" + new Date().getTime();
    document.getElementById("pageframe" + global.currPage).src = getIframeUrl(srcUrl);
    loading();
    document.getElementById("pageframe" + global.currPage).onload = function () {
        disLoad();
    }
}

//����ҽ��
function arrangeOrderBtnClick() {
    global.arrangeFlag = 1
    if ($('#arrangeOrderBtn .menu-text').html() == $g("ɾ������")) {
        global.arrangeFlag = 0
    }
    loadChart();
    $('#arrangeOrderBtn .menu-text').html(global.arrangeFlag == 1 ? $g("ɾ������") : $g("����ҽ��"))
}


//ҳ�����
var pageHandler = {  
    jumpPage: function(page){
        if (isValidPageNum(page)) {
            page = parseInt(page)
            chartHandler.visible(page)
            global.currPage = page;
            $("#pageInput").triggerbox('setValue', global.currPage);
            ///�л������б�
            var pageInfo = toIframeValue(page)
            var locNo = parseInt(pageInfo.LocNo) + 1
            $('#locsChange a[class*="clicked"]').removeClass("clicked")
            $('#locsChange a:nth-child(' + locNo + ')').addClass("clicked")
        }
    },
    //��ҳ
    firstPage: function(){
        pageHandler.jumpPage(1)
    },
    //βҳ
    lastPage: function(){
        pageHandler.jumpPage(global.totalPages)
    },
    //��һҳ
    prePage: function(){
        pageHandler.jumpPage(global.currPage-1)
    },
    //��һҳ
    nextPage: function(){
        pageHandler.jumpPage(global.currPage+1)
    }

}

//��ӡ����
var printHandler = {
    //��ȡ��Ҫ��ӡ�Ĵ�ӡ����
    getPrintData: function (page, ifXuPrint) {
        var iframeDoc = $(window.frames["pageframe" + page].document)
        var rectHtml = iframeDoc.find("#drawing rect")
        rectHtml.css("visibility", "hidden");
        var drawingDom = iframeDoc.find("#drawing")
        if (!!ifXuPrint) {
            if (drawingDom.find(".unPrinted").length == 0) {
                rectHtml.css("visibility", "visible");
                return ""
            }
            //�����ӡֻ��ӡclassΪunPrinted��Ԫ��
            var printedHtml = iframeDoc.find("#drawing .printed")
            printedHtml.css("visibility", "hidden");
            var printData = drawingDom.html()
            printedHtml.css("visibility", "visible");
        } else {
            var printData = drawingDom.html()
        }
        rectHtml.css("visibility", "visible");
        return printData
    },
    //lodop��ӡ
    LodopPrint: function (printData) {
        var LODOP = getLodop();
        LODOP.PRINT_INIT("ҽ����")
        LODOP.SET_PRINT_PAGESIZE(1, 2100, 2970, "A4");
        //printData = printData.replace(/\"blue\"/ig, "\"#000000\"")
        //LODOP.ADD_PRINT_HTML(0, 0, "100%", "100%", printData);
        //LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
        parseSVGintoLoadop(LODOP,printData)
        LODOP.PRINTA();
        //LODOP.PRINT_DESIGN()
    },
    //lodop������ӡ
    batchLodopPrint: function (ifXuPrint, startPage, endPage, callback) {
	    if (!isValidNum(startPage) || !isValidNum(endPage))
	    {
		    callback()
		    return
		}
        var LODOP = getLodop();
        LODOP.PRINT_INIT("ҽ������ӡ");
        LODOP.SET_PRINT_PAGESIZE(1, 2100, 2970, "A4");
        var printPage = 0;
        (function renderSinglePage(page) {
            if (page > parseInt(endPage)) {
                if (printPage != 0) {
                    //LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
                    LODOP.PRINT();
                }
                callback()
                return
            }
            if (!window.frames["pageframe" + page]) {
                //δ��Ⱦ��ҳ����Ⱦ
                chartHandler.render(page, false)
                $("#pageframe" + page).load(function () {
                    var printData = printHandler.getPrintData(page, ifXuPrint)
                    if (printData != "") {
                        //printData = printData.replace(/\"blue\"/ig, "\"#000000\"")
                        //LODOP.ADD_PRINT_HTML(0, 0, "100%", "100%", printData);
                        parseSVGintoLoadop(LODOP,printData)
                        printPage++;
                        if (printPage % 10 == 0) {
                            //LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
                            LODOP.PRINT();
                            printPage = 0
                        } else {
                            LODOP.NewPage();
                        }
                        //���򱣴��ӡ��¼  ����ҽ���������ӡ��¼
                        if (ifXuPrint && !global.arrangeFlag) {
                            printHandler.insertPrintRecord(page)
                        }
                    }
                    renderSinglePage(page + 1)
                })
            } else {
                var printData = printHandler.getPrintData(page, ifXuPrint)
                if (printData != "") {
                    //printData = printData.replace(/\"blue\"/ig, "\"#000000\"")
                    //LODOP.ADD_PRINT_HTML(0, 0, "100%", "100%", printData);
                    parseSVGintoLoadop(LODOP,printData)
                    printPage++;
                    if (printPage % 10 == 0) {
                        //LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
                        LODOP.PRINT();
                        printPage = 0
                    } else {
                        LODOP.NewPage();
                    }
                    //���򱣴��ӡ��¼  ����ҽ���������ӡ��¼
                    if (ifXuPrint && !global.arrangeFlag) {
                        printHandler.insertPrintRecord(page)
                    }
                }
                renderSinglePage(page + 1)
            }

        })(parseInt(startPage))
    },
    //ѡҳ��ӡ��������
    print: function (page) {
	    if (isValidNum(page))
	    {
        	printHandler.LodopPrint(printHandler.getPrintData(page, false))
	    }
    },
    //ѡҳ��Χ��ӡ
    printSelect: function(startPage, endPage){
	    loading("���ڴ�ӡ");
        printHandler.batchLodopPrint(false, startPage, endPage, function () {
            disLoad()
        })
	},
    //ȫ����ӡ, ������
    printAll: function () {
        loading("���ڴ�ӡ");
        printHandler.batchLodopPrint(false, 1, global.totalPages, function () {
            disLoad()
        })
    },
    //����
    printAllXu: function () {
        loading("���ڴ�ӡ");
        printHandler.batchLodopPrint(true, 1, global.totalPages, function () {
            disLoad()
            loadChart()
        })
    },
    //��ӡѡ����
    printRow: function () {
        var htmlStr = '<svg id="SvgjsSvg1001" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:svgjs="http://svgjs.com/svgjs" viewBox="0 0 210 297" style="overflow: visible;">'
        var iframeDoc = $(window.frames["pageframe" + global.currPage].document)
        var selectRowAry = iframeDoc.find("#drawing rect.clicked")
        if (selectRowAry.length == 0) {
            $.messager.popover({ msg: 'δѡ����', type: 'error' });
            return;
        }
        for (var i = 0, length = selectRowAry.length; i < length; i++) {
            var singleRow = selectRowAry[i]
            var rectId = $(singleRow).attr("id")
            var rowNum = rectId.split('_')[2]
            var textDocAry = iframeDoc.find("#drawing #text_row_" + rowNum)
            htmlStr += getOuterHTML(textDocAry);
        }
        /*�����ͷ��ҳ�� ������ �޸���ӡ�쳣����------*/
        var patInfoDocAry = iframeDoc.find("#drawing #text_row_patInfo").css("visibility", "hidden");
        htmlStr += getOuterHTML(patInfoDocAry);
        var headDocAry = iframeDoc.find("#drawing #text_row_head_1").css("visibility", "hidden");
        htmlStr += getOuterHTML(headDocAry);
        iframeDoc.find("#drawing #text_row_patInfo").css("visibility", "visible");
        iframeDoc.find("#drawing #text_row_head_1").css("visibility", "visible");
        /*--------------------------------------------*/
        htmlStr += '</svg>'
        printHandler.LodopPrint(htmlStr)
    },
    //�����ӡ��¼
    insertPrintRecord: function (page) {
        $cm({
            ClassName: "Nur.NIS.Service.OrderSheet.PrintRecord",
            MethodName: "InsertRecord",
            Type: global.sheetType,
            EpisodeId: episodeID,
            PrintUser: global.userID,
            Page: page,
            Record: JSON.stringify(toIframeValue(page).orders)
        },false)
    },
    //ɾ����ӡ��¼
    deletePrintRecord: function () {
        if (!global.arrangeFlag && isValidNum(global.currPage)) {
            $m({
                ClassName: "Nur.NIS.Service.OrderSheet.PrintRecord",
                MethodName: "deleteRecord",
                Type: global.sheetType,
                EpisodeId: episodeID,
                Page: global.currPage
            }, function (rtn) {
                if (rtn == 0) {
                    loadChart()
                } else {
                    $.messager.popover({ msg: rtn, type: 'error' });
                }
            })
        }
    }

}

//��Ⱦҽ��������
var chartHandler = {
    init: function () {
        $('#pageView').html("")
        global.currPage=0
        iframeFactory.remove()
    },
    //��Ⱦ
    render: function (pageNum, ifShow) {
        var srcUrl = "./nur.svg.ordersheet.csp?EpisodeID=" + episodeID + "&SheetType=" + global.sheetType
            + "&webIP=" + global.webIP + "&userID=" + global.userID + "&locID=" + global.locID + "&v=" + new Date().getTime();
        var myiframe = document.getElementById("pageframe" + pageNum)
        if (!myiframe) {

            var myiframe = iframeFactory.create()
            //myiframe=document.createElement("iframe");
            myiframe.id = "pageframe" + pageNum;
            myiframe.name = "pageframe" + pageNum;
            myiframe.width = global.iframeWidth + "%";
            myiframe.height = "100%";
            myiframe.style.position = "absolute";
            myiframe.style.zIndex = pageNum;
            if (ifShow) {
                if (global.currPage != 0) {
                    var currFrame = document.getElementById("pageframe" + global.currPage)
                    currFrame.style.zIndex = parseInt(currFrame.style.zIndex) - parseInt(global.totalPages);
                }
                global.currPage = pageNum;
                myiframe.style.zIndex = pageNum + parseInt(global.totalPages);
            }
            myiframe.setAttribute('marginwidth', '0');
            myiframe.setAttribute('marginheight', '0');
            myiframe.setAttribute('hspace', '0');
            myiframe.setAttribute('vspace', '0');
            myiframe.setAttribute('frameborder', '0');
            myiframe.src = getIframeUrl(srcUrl + "&page=" + pageNum);
            $("#pageView").append(myiframe);
        }
        else {
            var srcUrl = srcUrl + "&page=" + pageNum;
            myiframe.src = srcUrl;
        }
    },
    //��ʾҳ���ҽ����
    visible: function (page) {
        if (window.frames["pageframe" + page]) {
            var currFrame = document.getElementById("pageframe" + global.currPage);
            currFrame.style.zIndex = parseInt(currFrame.style.zIndex) - parseInt(global.totalPages);
            var jumpFrame = document.getElementById("pageframe" + page);
            jumpFrame.contentWindow.document.body.focus()
            jumpFrame.contentWindow.document.documentElement.scrollTop = 0
            jumpFrame.contentWindow.bottomLocation = false
            jumpFrame.contentWindow.topLocation = true
            jumpFrame.style.zIndex = parseInt(jumpFrame.style.zIndex) + parseInt(global.totalPages);
        } else {
            loading()
            chartHandler.render(page, true);
            $("#pageframe" + page).load(function () {
                disLoad();
            })
        }
    }

}

//��ͼ����
var viewHandler = {
	zoomIn: function(){
		viewHandler.resizePicture(1.05)
	},
	zoomOut: function(){
		viewHandler.resizePicture(0.95)
	},
	resizePicture: function(percent){
		var chartImg=$("#pageView")
	    if(chartImg){
	        var num=chartImg.css("flex-grow")
	        var width = num * percent
	        if(width<70){
	            $.messager.popover({msg: '�Ѿ�����СԤ��������',type:'alert'});
	            width = 70
	        }
	        if(width > 100){
	             $.messager.popover({msg: '�Ѿ������Ԥ��������',type:'alert'});
	             width = 100
	        }
	        global.iframeWidth = width
	        $("iframe").css("width",width+"%")
	        $("#pageView").css("flex-grow", width)
	        $("#rightView,#leftView").css("flex-grow", (100-parseInt(width))/2)
	    }

	}
}


//�ж��Ƿ�����Ч��ҳ��
function isValidPageNum(page) {
    if (!((/^\d*$/).test(parseInt(page)))) {
        $.messager.popover({ msg: '����ҳ�����!', type: 'error' });
        $("#pageInput").triggerbox('setValue', global.currPage);
        return false
    }
    if (page == 0) {
        $.messager.popover({ msg: '�Ѿ�����ҳ^_^', type: 'alert' });
        $("#pageInput").triggerbox('setValue', global.currPage);
        return false
    }
    if (page > global.totalPages) {
        $.messager.popover({ msg: '��' + global.totalPages + 'ҳ���޷���ת��' + page + 'ҳ^_^', type: 'alert' });
        $("#pageInput").triggerbox('setValue', global.currPage);
        return false
    }
    return true
}

function isValidNum(page) {
	var page = parseInt(page)
    if (!((/^\d*$/).test(page))) {
        return false
    }
    if (page <= 0 || page > global.totalPages ) {
        return false
    }
    return true
}


function getOuterHTML(docAry) {
    var htmlStr = ""
    for (var i = 0, length = docAry.length; i < length; i++) {
        var single = docAry[i]
        if (!!$(single).prop("outerHTML"))
        {
        	htmlStr += $(single).prop("outerHTML")
        }else{
	        htmlStr += new XMLSerializer().serializeToString(single)
	    }
    }
    return htmlStr
}

// ��ȡ��ǰҳ����ҽ������
function toIframeValue(pageNum) {
    var obj = global.sheetData.pages[parseInt(pageNum) - 1];
    if (!!!obj) {
        $.messager.popover({ msg: '������ҽ��', type: 'error' });
        return;
    }
    obj["totalRows"] = global.sheetData.totalRows
    return obj

}

// ��ȡCAͼǩ��
function toCAImages() {
    var obj = global.sheetData.CAImages
    return obj
}


// ��ȡCAͼǩ��
function toLogoImage() {
    var obj = global.sheetData.logoImage
    return obj
}

// ��ȡ�������
function toSheetConfig()
{
	var obj = global.sheetData.SheetConfig
    return obj
}


//��ȡ�ı�����
function toTextConfig()
{
	var obj = global.sheetData.TextConfig
    return obj
}



//��ȡͨ������
function toGeneralConfig()
{
	var obj = global.sheetData.GeneralConfig
	obj["totalPage"] = global.totalPages
    return obj
}

function setEprMenuForm(adm, papmi, mradm, canGiveBirth) {
    var frm = dhcsys_getmenuform();
    if ((frm) && (frm.EpisodeID.value != adm)) {
        frm.EpisodeID.value = adm;
        frm.PatientID.value = papmi;
        frm.mradm.value = mradm;
    }
}

//�������ز�
function loading(msg) {
    $.messager.progress({
        title: "��ʾ",
        msg: !!msg ? msg : '���ڻ���ͼƬ',
        text: $g('����΢���ĵȴ�һ����Ŷ....')
    });
}
//ȡ�����ز�  
function disLoad() {
    $.messager.progress("close");
}

//����svg��lodop��ӡ���������δװie11��ӡ���˺ʹ�ӡģ��������
function parseSVGintoLoadop(LODOP,printData){
	//����xml
	var docobj = DHC_parseXml(printData)
	//��ӡͼƬ
	var picDataParas = docobj.getElementsByTagName("image");
	if (picDataParas && picDataParas.length>0){
		for (var j=0;j<picDataParas.length;j++){
			var item = picDataParas[j]
			 if (item.style.visibility == "hidden")
            {
                continue;
            }
			var pleft = item.getAttribute("x");	
			var ptop = item.getAttribute("y");	
			var pheight = parseFloat(item.getAttribute("height"))*3;
			var pwidth = parseFloat(item.getAttribute("width"))*3;
			var pval = item.getAttribute("xlink:href");
			LODOP.ADD_PRINT_IMAGE(ptop+"mm",pleft+"mm", pwidth+"mm", pheight+"mm","<img src='"+ pval +"' width="+ pwidth +" height=" + pheight + " x="+ pleft +" y=" + ptop + "/>");
		}
	}
	//��ӡ��
    var pLines = docobj.getElementsByTagName("line");
	if (pLines && pLines.length>0){
		for (var j=0;j<pLines.length;j++){
			var item = pLines[j]
			 if (item.style.visibility == "hidden")
            {
                continue;
            }
			var pleft1 = item.getAttribute("x1");	
			var ptop1 = item.getAttribute("y1");	
			var pleft2 = item.getAttribute("x2");	
			var ptop2 = item.getAttribute("y2");
            var lineWidth = item.getAttribute("stroke-width");
			LODOP.ADD_PRINT_LINE(ptop1+"mm",pleft1+"mm",ptop2+"mm",pleft2+"mm",0,lineWidth);
		}
	}
	//��ӡ�ı�
	 var txtDataParas = docobj.getElementsByTagName("text");
	if (txtDataParas && txtDataParas.length>0){
		for (var j=0;j<txtDataParas.length;j++){
			var itm = txtDataParas[j]
            if (itm.style.visibility == "hidden")
            {
                continue;
            }
			var pleft = parseFloat(itm.getAttribute("startX"))-0.3;	
			var ptop = itm.getAttribute("y");		
			var pfbold = itm.getAttribute("font-weight");
			var pfname = itm.getAttribute("font-family");
			var pfsize = itm.getAttribute("font-size");
			var anchor = itm.getAttribute("anchor");
			var pwidth = parseFloat(itm.getAttribute("width"))+2;
            var pheight = itm.getAttribute("font-size");
			var childNodes = itm.childNodes
			if (childNodes && childNodes.length > 0)
			{
				for (var i=0;i<childNodes.length;i++){
					var singleChild = childNodes[i]
					var pval = singleChild.innerHTML
                    var curPtop = parseFloat(ptop) + 3 * i
					LODOP.ADD_PRINT_TEXT(curPtop +"mm",pleft+"mm",pwidth+"mm",pheight+"mm",pval);
			
					LODOP.SET_PRINT_STYLEA(0,"FontSize",parseFloat(pfsize)*2.5);
					LODOP.SET_PRINT_STYLEA(0,"FontName",pfname);
					var AlignmentNum = 1
					if (anchor=="middle")
					{
						AlignmentNum = 2
					}else if(anchor=="end")
					{
						AlignmentNum = 3
					}
					LODOP.SET_PRINT_STYLEA(0,"Alignment",AlignmentNum);
					LODOP.SET_PRINT_STYLEA(0,"TextNeatRow","1")
					if (pfbold == "bold")
					{
						LODOP.SET_PRINT_STYLEA(0,"Bold","1")
					}
				}
			}
			
		}
	}
	
}


function DHC_parseXml(strXml){
	if (!!window.ActiveXObject || "ActiveXObject" in window){
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		//docobj.async = false;    //
		var rtn=docobj.loadXML(strXml);
		if (rtn) return docobj;
	}else{  //Chrome 
		var parser=new DOMParser();
		var docobj=parser.parseFromString(strXml,"text/xml");
		//DHC_removeTextNode(docobj);
		docobj.parsed=true;  //�������ж�docobj.parsed  ǿ�и�ֵ
		return docobj;
	}
	return null;
}

function getIframeUrl(url){
	if ('undefined'!==typeof websys_getMWToken){
		if(url.indexOf("?")==-1){
			url = url+"?MWToken="+websys_getMWToken()
		}else{
			url = url+"&MWToken="+websys_getMWToken()
		}
	}
	return url
}