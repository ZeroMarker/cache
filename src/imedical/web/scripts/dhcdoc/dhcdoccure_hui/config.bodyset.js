var PageLogicObj={
	CureBodyPointDataGrid:"",
	PreClickBodyImage:""
}
$(document).ready(function(){
	Init();
	PageHandle();
	InitEvent();
	LoadCureBodyPointDataGrid();
})

function Init(){
	PageLogicObj.CureBodyPointDataGrid=InitCureBodyPointDataGrid();
	document.onkeydown = Page_OnKeyDown;
}

function PageHandle(){
}

function InitEvent(){
	$(".div-body-img").click(function(e){
        AddPoint(this,e);
    })
    
    $("#btnSaveClickPoint").click(function(e){
        SaveClickPoint();
    })
}

function InitCureBodyPointDataGrid(){
	var CureBodyPointDataGrid=$('#CureBodyPointDataGrid').datagrid({  
		fit : true,
		width : 'auto',
		url : '',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: true,
		collapsible:false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"Id",
		pageSize : 10,
		pageList : [10,20],
		columns :[[ 
			{field:'Id',title:'Id',width:20,align:'left', hidden: true},  
			{field:'BodyImageId',title:'所属图片Id',width:120,align:'left', resizable: true},
			{field:'BodyImage',title:'所属图片',width:80,align:'left', resizable: true},
			{field:'BodyPointDesc',title:'部位描述',width:100,align:'left', resizable: true},
			{field:'BodyPointValue',title:'部位像素点值',width:400,align:'left', resizable: true}
		]],
		toolbar:[{
	        text: '删除',
	        iconCls: 'icon-remove',
	        handler: function() {
		        var row=PageLogicObj.CureBodyPointDataGrid.datagrid("getSelected");
		        if(row){
			        var RowId=row.Id;
			        var BodyImageId=row.BodyImageId;
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.Config",
						MethodName:"DelCureBody",
						Id:	RowId
					},function(ret){
						if(ret==0){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							LoadCureBodyPointDataGrid();
							ClearContext(BodyImageId)
						}else{
							$.messager.alert("警告","删除失败,错误代码:"+ret,"warning");
							return false;		
						}
					})	
		        }else{
			        $.messager.alert("警告","请选择一行需要删除的记录","warning")
			    }
	        }
	    }
		],
		onClickRow:function(rowIndex, rowData){
			showBodyDetail(rowData);
			var BodyImage=rowData.BodyImage;
			if(BodyImage.indexOf("女")>=0){
				$("#sex_tabs").tabs("select","女性");
			}else{
				$("#sex_tabs").tabs("select","男性");
			}
		}
	});
	return CureBodyPointDataGrid;	
}

function AddPoint(that,e){
	if(typeof(PageLogicObj.PreClickBodyImage)=='object'){
		var lastObj=PageLogicObj.PreClickBodyImage.lastChild;
		if(($(lastObj).hasClass("div-click-flag"))||($(lastObj).hasClass(".div-click-flag"))){
			if(PageLogicObj.PreClickBodyImage!=that){
				 $.messager.alert("警告","请先保存上一个部位的像素点值.","warning");
				 return false;
			}
		}
	}else{
		PageLogicObj.PreClickBodyImage=that;
	}
	var radius=1;
    var offset=$(that).offset();
    var yPoint=e.pageY-offset.top;
    var xPoint=e.pageX-offset.left;
    var yPointVal=e.pageY-offset.top-radius+"px";
    var xPointVal=e.pageX-offset.left-radius+"px";
    //console.log(e.pageY+","+offset.top+","+yPoint+","+xPoint);
    $(that).append('<div class="div-click-flag" id="'+xPoint+"@"+yPoint+'" style="top:'+yPointVal+';left:'+xPointVal+'"></div>')
}

function SaveClickPoint(){
	var BodyPointDesc=$("#BodyPointDesc").val();
	if(BodyPointDesc==""){
		$.messager.alert("警告","部位描述不能为空.","warning");
		return false;	
	}
	var PointObj=$(".div-click-flag");
	var PointCount=PointObj.length;
	if(PointCount<3){
		$.messager.alert("警告","部位像素点需要至少三个点.","warning");
		return false;	
	}
	var BodyPointArr=[];
	for(var i=0;i<PointCount;i++){
		BodyPointArr.push(PointObj[i].id)
	}
	var BodyPointVal=BodyPointArr.join(",");
	var BodyImageId=PageLogicObj.PreClickBodyImage.id;
	//BodyImageId=BodyImageId.replace(/-/g,"")
	var params=BodyPointDesc+"^"+BodyPointVal+"^"+session['LOGON.HOSPID'];
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"SaveCureBody",
		BodyImageId:BodyImageId,
		params:	params,
		_headers:{"X_ACCEPT_TAG":1}
	},function(ret){
		if(ret==0){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			ClearClickBodyPoint();
			LoadCureBodyPointDataGrid();
		}else if(ret=="-1"){
			$.messager.alert("警告","该部位描述已存在.","warning");
			return false;	
		}else{
			$.messager.alert("警告","保存失败,错误代码:"+ret,"warning");
			return false;		
		}
	})
}

function ClearClickBodyPoint(){
	$("#BodyPointDesc").val("");
	if(typeof(PageLogicObj.PreClickBodyImage)=='object'){
		$(".div-click-flag").remove();
		PageLogicObj.PreClickBodyImage="";
	}
}

function LoadCureBodyPointDataGrid(){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"QueryCureBody",
		BodyImageId:"",
		Pagerows:PageLogicObj.CureBodyPointDataGrid.datagrid("options").pageSize,
		rows:99999	
	},function(GridData){
		PageLogicObj.CureBodyPointDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})	
}
function ClearContext(BodyImageId){
	var BodyImageId=BodyImageId+"-diagonal";
	var canvers = document.getElementById(BodyImageId);
	var context = canvers.getContext("2d");
	context.clearRect(0, 0, canvers.width, canvers.height);	
}

/**
* 选中人体部位，高亮显示
* @param {*} id 画布id
* @param {*} objs 人体对象id数组（男女）
*/
function showBodyDetail(rowData){
	var BodyImageId=rowData.BodyImageId+"-diagonal";
	var BodyPointValue=rowData.BodyPointValue;
	BodyPointValue=BodyPointValue.replace(/@/g,",");
	var canvers = document.getElementById(BodyImageId);
	var context = canvers.getContext("2d");
	context.clearRect(0, 0, canvers.width, canvers.height);
	var strs = new Array(); //定义一数组
	context.beginPath();
	strs = BodyPointValue.split(",");//选择部位的坐标
	//使用画布描出坐标
	var i1, i2;
	for (var i = 0; i < strs.length; i++) {
	    if (i % 2 == 0) {
	        i1 = strs[i];
	    }
	    if (i % 2 == 1) {
	        i2 = strs[i];
	        if (i == 1) {
	            context.moveTo(i1, i2);
	        }
	        else {
	            context.lineTo(i1, i2);
	        }
	    }
	}
	context.globalAlpha = 0.5;  
	context.fillStyle = "#FF0000";
	//context.clearRect(0, 0, 350, 700);
	context.fill();
	//context.closePath(); //闭合

}

function Page_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    var keyCode=e.keyCode || e.which || e.charCode;
    if (ctrlKeyFlag){
	    if(keyCode==90){
		    var lastObj=PageLogicObj.PreClickBodyImage.lastChild;
		    if(($(lastObj).hasClass("div-click-flag"))||($(lastObj).hasClass(".div-click-flag"))){
		    	$(lastObj).remove();
		    }
		}else{
        	return false;
		}
	}
}