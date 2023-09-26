var tmpcategoryId = "";

$(function(){
	initCbCategory();
});

function initCbCategory()
{
	$('#cbCategory').combobox({  
	    url:'../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLTextKBCategory&Method=GetCategory',  
	    valueField:'id',  
	    textField:'text',
	    onLoadSuccess : function(){  
	    	var data = $('#cbCategory').combobox('getData');
	    	if (data.length > 0)
		  	$('#cbCategory').combobox('select',data[0].id); 
		  	document.getElementById('content').innerHTML="";  
		  	initcbLoc();
		},
	    onSelect: function(rec)
	    {  
	    	var tmpLocId = getUserLocID();
 			getCategory(rec.id,tmpLocId);
        }
  
	}); 
	 
}

function initcbLoc()
{
	var categoryId = getCagegoryID();
	$('#cbLoc').combobox({  
	    url:'../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLTextKBCategory&Method=GetTextKBLoc&p1='+categoryId+'&p2=',  
	    valueField:'RowID',  
	    textField:'Desc',
	    onLoadSuccess : function(){  
		  	$('#cbLoc').combobox('select',userLocID);   
		},
	    onSelect: function(rec)
	    { 
	    	document.getElementById('content').innerHTML="";
		    var tmpLocId = getUserLocID();
		    var parentId = getCagegoryID();
			getCategory(parentId,tmpLocId);
        }
  
	}); 	
}

function getInsertText()
{
    var txt = "";
    if (window.getSelection)
    {
	    var userSelection = window.getSelection();
	    var range = userSelection.getRangeAt(0);
	    var container = document.createElement('div');
    	container.appendChild(range.cloneContents());
		txt = container.innerText;
	}
	else
	{
		txt = document.selection.createRange().htmlText;
	}
	if (txt == "" || txt == undefined)
	{
		txt = document.getElementById('content').innerHTML;
	}
	txt = txt.replace(/<br\s*\/?>/g, "\n");
	txt = txt.replace(/&nbsp;/g," ");
	var param = {"action":"insertText","text":txt}
	parent.eventDispatch(param);  
}

$("#insert").click(function(){
	  getInsertText();
})

$("#insertclose").click(function(){
	  getInsertText();
	  parent.foldResource("close");
})

$("#close").click(function(){
	  parent.foldResource("close");
})

$("#new").click(function(){
	if (tmpcategoryId == ""){
		alert("����ѡ��Ŀ¼�ڵ�");
	} else {
		var array = new Array(0);
		array[0] = tmpcategoryId;
		var returnValues = window.showModalDialog("emr.edit.kbtext.csp",array,"dialogLeft:1000px;dialogHeight:765px;dialogWidth:700px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
	}
})

///����Ŀ¼
function getCategory(parentId,paramLoc)
{	 
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTextKBCategory",
			"Method":"GetData",
			"p1":parentId,
			"p2":paramLoc
		},
		success: function(d) {
			$.fn.zTree.init($('#kbCategory'),ztSetting,d);
        	var treeObj = $.fn.zTree.getZTreeObj('kbCategory');
        	treeObj.expandAll(true);
	
		},
		error : function(d) { alert("getCategory error");}
	});	
}

///����Ŀ¼
var ztSetting =
{
    view :
    {
        showIcon : false
    },
    callback :
    {
        onClick : ztOnClick
    },
    data :
    {
        simpleData :
        {
            enable : false
        }
    }
};

//ztree����������ص�����
function ztOnClick(event, treeId, treeNode)
{
    if (treeNode.attributes.type != "leaf") 
	{
		tmpcategoryId = treeNode.id;	
		return
	}
	tmpcategoryId = "";
	setContent(treeNode.id);
}

///��������
function setContent(categoryId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTextKBContent",
			"Method":"GetContent",
			"p1":categoryId
		},
		success: function(d) {
			//$("#content").text(d);
			document.getElementById('content').innerHTML=d; 
		},
		error : function(d) { alert("GetContent error");}
	});		
}
 
 function getUserLocID()
 {
	var tmpLocId = $('#cbLoc').combobox('getValue');
	return tmpLocId;	 
 }
 
 function getCagegoryID()
 {
	 var categoryId = $('#cbCategory').combobox('getValue');
	 return categoryId;
 }