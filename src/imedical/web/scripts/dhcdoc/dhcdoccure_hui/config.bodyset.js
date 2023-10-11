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
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"Id",
		pageSize : 10,
		pageList : [10,20],
		columns :[[ 
			{field:'Id',title:'Id',width:20,align:'left', hidden: true},  
			{field:'BodyImageId',title:'����ͼƬId',width:120,align:'left', resizable: true},
			{field:'BodyImage',title:'����ͼƬ',width:80,align:'left', resizable: true},
			{field:'BodyPointDesc',title:'��λ����',width:100,align:'left', resizable: true},
			{field:'BodyPointValue',title:'��λ���ص�ֵ',width:400,align:'left', resizable: true}
		]],
		toolbar:[{
	        text: 'ɾ��',
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
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
							LoadCureBodyPointDataGrid();
							ClearContext(BodyImageId)
						}else{
							$.messager.alert("����","ɾ��ʧ��,�������:"+ret,"warning");
							return false;		
						}
					})	
		        }else{
			        $.messager.alert("����","��ѡ��һ����Ҫɾ���ļ�¼","warning")
			    }
	        }
	    }
		],
		onClickRow:function(rowIndex, rowData){
			showBodyDetail(rowData);
			var BodyImage=rowData.BodyImage;
			if(BodyImage.indexOf("Ů")>=0){
				$("#sex_tabs").tabs("select","Ů��");
			}else{
				$("#sex_tabs").tabs("select","����");
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
				 $.messager.alert("����","���ȱ�����һ����λ�����ص�ֵ.","warning");
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
		$.messager.alert("����","��λ��������Ϊ��.","warning");
		return false;	
	}
	var PointObj=$(".div-click-flag");
	var PointCount=PointObj.length;
	if(PointCount<3){
		$.messager.alert("����","��λ���ص���Ҫ����������.","warning");
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
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			ClearClickBodyPoint();
			LoadCureBodyPointDataGrid();
		}else if(ret=="-1"){
			$.messager.alert("����","�ò�λ�����Ѵ���.","warning");
			return false;	
		}else{
			$.messager.alert("����","����ʧ��,�������:"+ret,"warning");
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
* ѡ�����岿λ��������ʾ
* @param {*} id ����id
* @param {*} objs �������id���飨��Ů��
*/
function showBodyDetail(rowData){
	var BodyImageId=rowData.BodyImageId+"-diagonal";
	var BodyPointValue=rowData.BodyPointValue;
	BodyPointValue=BodyPointValue.replace(/@/g,",");
	var canvers = document.getElementById(BodyImageId);
	var context = canvers.getContext("2d");
	context.clearRect(0, 0, canvers.width, canvers.height);
	var strs = new Array(); //����һ����
	context.beginPath();
	strs = BodyPointValue.split(",");//ѡ��λ������
	//ʹ�û����������
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
	//context.closePath(); //�պ�

}

function Page_OnKeyDown(e){
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
	//�������Backspace������  
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