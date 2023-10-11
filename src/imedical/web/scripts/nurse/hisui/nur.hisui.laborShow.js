/*
 * @Author: ouzilin 
 * @Date: 2022-09-01 10:42:51 
 * @Last Modified by: ouzilin
 * @Last Modified time: 2023-04-14 11:19:11
 */
$.extend($.fn.datagrid.methods, {
	getEditingRowIndex: function(jq){
		var rows= $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
		var indexs = [];
		rows.each(function(i, row){
			var index = row.sectionRowIndex;
			if (indexs.indexOf(index) == -1)
			{
				indexs.push(index);
			}
		})
		return indexs
	}
})

var GV = {
    _CLASSNAME: "Nur.NIS.Service.Labor.Handler",
	hospId: session['LOGON.HOSPID'],
	userId: session['LOGON.USERID'],
	page:1,
	totalPage:2,
	ifHorizontalPrint:"" //�Ƿ����ӡ
} 

$(function() {
    initUI()
})

function initUI(){
	if (NewBanner=="1")
	{
		InitPatInfoBanner(EpisodeID);
	}
	initSearchTable()
	initRecordGrig()
	initPageView()
}

/**
 * ��ʼ�� ¼�����ͷ����Ϣ
 */
function initSearchTable(){

	GV.ifHorizontalPrint = $m({
		ClassName:GV._CLASSNAME,
		MethodName:"ifHorizontalPrint",
		HospID:GV.hospId
	},false)


	GV.totalPage = $cm({
		ClassName:GV._CLASSNAME,
		MethodName:"getPages",
		EpisodeID:EpisodeID
	},false)
	GV.page = GV.totalPage
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName:"getLaborInfo",
		episodeID:EpisodeID
	},function(data){
		$('#contraDate').datebox('setValue',data.contraDate);
		$('#contraTime').timespinner('setValue',data.contraTime);
		$('#placentaOutDate').datebox('setValue',data.placentaOutDate);
		$('#placentaOutTime').timespinner('setValue',data.placentaOutTime);
		$('#pregnancy').val(data.pregnancy);
		$('#parturition').val(data.parturition);
		$("#multBirthsFlag")['switchbox']('setValue',data.multBirthsFlag =="Y" ? true : false)
	})

	$('#saveBtn').on('click',function(){
		var jsonData = {
			contraDate: $('#contraDate').datebox('getValue'),
			contraTime: $('#contraTime').timespinner('getValue'),
			placentaOutDate: $('#placentaOutDate').datebox('getValue'),
			placentaOutTime: $('#placentaOutTime').timespinner('getValue'),
			pregnancy: $('#pregnancy').val(),
			parturition:  $('#parturition').val()
		}
		if (jsonData.contraDate=="" || jsonData.contraTime=="")
		{
			$.messager.popover({ msg: "������ʼʱ�䲻��Ϊ��", type:'error' });
			return
		}
		$cm({
			ClassName:GV._CLASSNAME,
			MethodName:"saveLaborInfo",
			episodeID:EpisodeID,
			jsonData: JSON.stringify(jsonData),
			userID: GV.userId
		},function(data){
			if (data.code == 0){
				$.messager.popover({ msg: '����ɹ�', type:'success' });
				hrefRefresh()
			}else{
				$.messager.popover({ msg: data.error, type:'error' });
				return
			}
		})
	})

	$('#printStageLabor').on('click',function(){
		printAll(false)
	})

	$('#firstPreview').on('click',function(){
		GV.page = 1
		hrefRefresh(GV.page)
	})
	$('#secondPreview').on('click',function(){
		GV.page = 2
		hrefRefresh(GV.page)
	})

	if (GV.totalPage!=2)
	{
		$('#secondPreview').hide()
	}
	$('#searchBtn').on('click',function(){
		$("#recordGrid").datagrid("reload")
	})
	$('#printRecord').on('click',function(){
		printLaborRec()
	})	

}

function multBirthsFlagChange(obj)
{
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName:"multBirthsFlagChange",
		episodeID:EpisodeID,
		flag: (obj.value ? "Y":"N"),
		userID: GV.userId
	},function(data){
		if (data.code == 0){
			initRecordGrig()
			hrefRefresh()
		}else{
			$.messager.popover({ msg: data.error, type:'error' });
			return
		}
	})
}

/**
 * ��ʼ�� ¼����
 */
function initRecordGrig(){
	var columns = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: 'getColumns',
		hospId: GV.hospId,
		episodeId: EpisodeID
	},false)
	var frozenColumns = [
		{field:'ID',hidden:true},
		{field: "oper",title: "����",width:70,formatter: function(val, row, index) {
		return   "&nbsp<a onclick='saveRecord("+ index +")' class='icon-save' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
			   + "&nbsp&nbsp&nbsp"
		       + "<a onclick='deleteRecord("+ index +")' class='icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
		       + "&nbsp"
		}}
	]
	columns.unshift(
		{field: "recDate",title: "����",width:110,editor:"dateboxq"},
		{field: "recTime",title: "ʱ��",width:80,editor:"timespinner"}
	)
	columns.push({field: "recUser",title: "ǩ��",width:80})
	$("#recordGrid").datagrid({
		url: $URL,
		singleSelect: true,
		striped: true,
		nowrap: false,
		frozenColumns: [frozenColumns],
		columns: [columns],
		rownumbers: true,
		onBeforeLoad: function(param) {
            param.ClassName = GV._CLASSNAME
            param.MethodName = "getRecords"
            param.episodeId = EpisodeID
			param.hospId = GV.hospId
        },
		onDblClickRow: function(rowIndex, rowData){
			var rows = $(this).datagrid('getRows')
			if ( $.isEmptyObject(rows[rowIndex]))	
			{
				$(this).datagrid("rejectChanges");
			}
            $(this).datagrid("unselectAll");
			var row = $(this).datagrid('getRows')[rowIndex];
			if(row.recDate==undefined){
				var serverDT=getServerTime();
				row.recDate=serverDT.date;
				row.recTime=serverDT.time;
			}
            $(this).datagrid("beginEdit", rowIndex);
            $(this).datagrid("selectRow",rowIndex);
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('appendRow', { });
        },
        onBeginEdit: function(index, row) {
			var datagridAPI = $('#recordGrid').datagrid('getEditor', {index: index, field: 'blood'});
			var inputFields = $(datagridAPI.target).closest('.datagrid-body').find('input[type=text], input[type=checkbox], select,textarea');
			inputFields.on('keydown', function(event) {
			  var key = event.keyCode;
			  var nextField;
			  switch (key) {
			    case 37: // ���ͷ
			      nextField = $(this).closest('td').parent().closest('td').prev().find('input[type=text], input[type=checkbox], select,textarea');
			      break;
			    case 39: // �Ҽ�ͷ
			      nextField = $(this).closest('td').parent().closest('td').next().find('input[type=text], input[type=checkbox], select,textarea');
			      break;
			    case 13: // �¼�ͷ
			    	var indexs = $("#recordGrid").datagrid("getEditingRowIndex")
			    	saveRecord(indexs[0],function(){
				    	var rows = $('#recordGrid').datagrid('getRows')
						if ( $.isEmptyObject(rows[indexs[0]+1]))	
						{
							$('#recordGrid').datagrid("rejectChanges");
						}
				    	$('#recordGrid').datagrid("unselectAll");
						var row = $('#recordGrid').datagrid('getRows')[indexs[0]+1];
						if(row.recDate==undefined){
							var serverDT=getServerTime();
							row.recDate=serverDT.date;
							row.recTime=serverDT.time;
						}
				    	$('#recordGrid').datagrid('beginEdit', indexs[0]+1);
				    	$('#recordGrid').datagrid('selectRow', indexs[0]+1);
				    	var datagridEdit = $('#recordGrid').datagrid('getEditor', {index: indexs[0]+1, field: 'fetalHeart'});
				    	$(datagridEdit.target).focus();
				    })
			      	nextField = null
			      break;
			    default:
			      return;
			  }
			  if (nextField && nextField.length) {
			    // �������л�����һ�������
			    nextField.focus();
			    nextField.click();
			    // ȡ��������Ԫ��ı༭״̬
			    inputFields.not(nextField).each(function() {
			      var editor = $(this).closest('.datagrid-row-editing').find('.datagrid-editable-input');
			      editor.triggerHandler('blur');
			    });
			  }
			});
        }
	});
	
	
	
  
}

/**
 * �����¼
 * @param {*} rowIndex 
 */
function saveRecord(rowIndex,callback){
	var indexs = $('#recordGrid').datagrid('getEditingRowIndex');
	if (indexs.length != 0)
	{
		$('#recordGrid').datagrid('endEdit',indexs[0])
	}
	var row = $("#recordGrid").datagrid('getRows')[rowIndex];
	$("#recordGrid").datagrid('updateRow',{index:rowIndex,row:row})
	$('#recordGrid').datagrid("acceptChanges");
	if (!row.recDate || !row.recTime)
	{
		$.messager.popover({ msg: '���ں�ʱ�䲻��Ϊ��!', type:'error' });
		return
	}
	$cm({
		ClassName: GV._CLASSNAME,
		MethodName: "saveRecord",
		episodeId: EpisodeID,
		jsonData: JSON.stringify(row),
		userId: GV.userId
	},function(data){
		if (data.code == 0){
			$.messager.popover({ msg: '����ɹ�', type:'success' });
			hrefRefresh()
			if (!!callback)
			{
				callback()
			}else{
				$("#recordGrid").datagrid("reload")
			}
        }else{
            $.messager.popover({ msg: data.error, type:'error' });
            return
        }
	})
}

/**
 * ɾ����¼
 * @param {*} rowIndex 
 */
function deleteRecord(rowIndex){
	var indexs = $('#recordGrid').datagrid('getEditingRowIndex');
	if (indexs.length != 0)
	{
		$('#recordGrid').datagrid('endEdit',indexs[0])
	}
	var row = $("#recordGrid").datagrid('getRows')[rowIndex];
	$cm({
		ClassName: GV._CLASSNAME,
		MethodName: "deleteRecord",
		episodeId: EpisodeID,
		jsonData: JSON.stringify(row),
		userId: GV.userId
	},function(data){
		if (data.code == 0){
			$.messager.popover({ msg: 'ɾ���ɹ�', type:'success' });
			$("#recordGrid").datagrid("reload")
			hrefRefresh()
        }else{
            $.messager.popover({ msg: data.error, type:'error' });
            return
        }
	})
}

/**
 * ��ȡϵͳʱ��
 * @param {*} timeFormat 
 * @param {*} systemFormat 
 * @returns 
 */
function getServerTime() {
    var jsonData = $cm({
        ClassName: "Nur.NIS.Service.Labor.Handler",
        MethodName: "getCurrentDateTime"
    }, false);
    return jsonData;
}


/**
 * ����Ԥ������
 */
function initPageView(){
	var srcUrl="./nur.svg.labor.csp?EpisodeID="+EpisodeID+"&ifHorizontalPrint="+GV.ifHorizontalPrint+"&page="+GV.page
    $("#iframePicture").attr("src",getIframeUrl(srcUrl)); 
}


/**
 * ��ӡ����ͼ
 */
function printAll(ifPreview,loadSuccess){
	
	var data = $cm({
		ClassName : "Nur.NIS.Service.Labor.Handler",
		MethodName : "ifAllowPrint",
		episodeId : EpisodeID,
		userId:GV.userId
	},false)
	if (data.code != "1")
	{
		$.messager.popover({ msg: data.error, type:'error' });
		return
	}
	loading("���ڴ�ӡ");	        
	var printElem=$("#iframePicture").contents().find("#print");
	if(printElem.length>0){
		$("#iframePicture").contents().find("#print").remove();    
	}
	var loadFlag=loadSuccess ? loadSuccess : document.getElementById("iframePicture").contentWindow.loadSuccess;
	if(!loadFlag){
		document.getElementById("iframePicture").contentWindow.multiRequest(GV.totalPage,3,ifPreview);		
	}else{		        
		var drawing=$("#iframePicture").contents().find("#drawing");
		drawing.after(drawing.clone().attr("id","print").hide());
		var LODOP=getLodop();
		LODOP.PRINT_INIT("��ӡ����ͼ");
		LODOP.SET_PRINT_PAGESIZE( ((GV.ifHorizontalPrint == "Y") ? 2 : 1), 2100,2970,"A4");
		//LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");            
		for(var i=1;i<=GV.totalPage;i++){
			if(document.getElementById("iframePicture").contentWindow.conObj[i]){
					printChart(i,LODOP);	
					LODOP.NewPage();
			}
			/*	
			$("#iframePicture").contents().find("#print .content").css("visibility",'hidden');
			if($("#iframePicture").contents().find("#print #content-"+i).length>0){
				$("#iframePicture").contents().find("#print #content-"+i).css("visibility","visible");	
				var printData = document.getElementById('iframePicture').contentWindow.document.getElementById("print").innerHTML;            
				//parseSVGintoLoadop(LODOP,printData)    
				LODOP.ADD_PRINT_HTML(0,0,"100%", "100%",printData);   
				LODOP.NewPage();
				$("#iframePicture").contents().find("#print #content-"+i).remove();					            
			}	
			*/					
		}
		if(ifPreview){
			LODOP.PREVIEW();
		}
		else{
			LODOP.PRINT();
			//LODOP.PRINTA();
		}					
	}
	document.getElementById("iframePicture").contentWindow.loadSuccess=false;
	disLoad();
}

function hrefRefresh(page){
	GV.totalPage = $cm({
		ClassName:GV._CLASSNAME,
		MethodName:"getPages",
		EpisodeID:EpisodeID
	},false)
	if (GV.totalPage!=2)
	{
		$('#secondPreview').hide()
	}else{
		$('#secondPreview').show()
	}
	if (!!page)
	{
		GV.page = page	
	}else{
		GV.page = GV.totalPage	
	}
	//$("#iframePicture").contents().find(".content").hide();
	document.getElementById("iframePicture").contentWindow.page=GV.page;              
	document.getElementById("iframePicture").contentWindow.getCurData(GV.page);
}

 //�������ز�
 function loading(msg) {
	$.messager.progress({
		title: "��ʾ",
		msg: msg,
		text: '����΢���ĵȴ�һ����Ŷ....'
	});
}
//ȡ�����ز�  
function disLoad() {
	$.messager.progress("close");
}  


//����svg��lodop��ӡ����
function parseSVGintoLoadop(LODOP,printData){
	//����xml
	var docobj = DHC_parseXml(printData)
	//��ӡͼƬ
	var picDataParas = docobj.getElementsByTagName("image");
	if (picDataParas && picDataParas.length>0){
		for (var j=0;j<picDataParas.length;j++){
			var item = picDataParas[j]
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
			var pleft1 = item.getAttribute("x1");	
			var ptop1 = item.getAttribute("y1");	
			var pleft2 = item.getAttribute("x2");	
			var ptop2 = item.getAttribute("y2");
			LODOP.ADD_PRINT_LINE(ptop1+"mm",pleft1+"mm",ptop2+"mm",pleft2+"mm",0,1);
		}
	}
	//��ӡ�ı�
	 var txtDataParas = docobj.getElementsByTagName("text");
	if (txtDataParas && txtDataParas.length>0){
		for (var j=0;j<txtDataParas.length;j++){
			var pwidth  = 800
			var pheight = 800
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
			var childNodes = itm.childNodes
			if (childNodes && childNodes.length > 0)
			{
				for (var i=0;i<childNodes.length;i++){
					var singleChild = childNodes[i]
					var pval = singleChild.innerHTML
                    var curPtop = parseFloat(ptop) + 3 * i
					LODOP.ADD_PRINT_TEXT(curPtop +"mm",pleft+"mm",pwidth+"mm",pheight+"mm",pval);
			
					LODOP.SET_PRINT_STYLEA(0,"FontSize",parseFloat(pfsize)*2.5);
					//LODOP.SET_PRINT_STYLEA(0,"FontName",pfname);
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