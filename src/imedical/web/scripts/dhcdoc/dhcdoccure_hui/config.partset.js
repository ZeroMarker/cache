var PageLogicObj={
	CurePartSetDataGrid:"",
	PartType:[{id:"BP",desc:"部位"},{id:"A",desc:"穴位"}]
}

$(document).ready(function(){ 
	InitHospUser();
	InitEvent();
	InitPartType();
});	
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		CurePartSetDataGridLoad();
		ClearAcupDetail();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.CurePartSetDataGrid=Init();
		CurePartSetDataGridLoad();
	}	
}

function InitEvent(){
	$('#btnSave').click(function(){
		SaveFormData()
	});	
	$('#btnSaveDetailSet').click(function(){
		SaveAcupDetail();
	});	
	$('#btnDelAcupImgDiagram').click(function(){
		DelAcupImgDiagram();
	});
}

function InitPartType(){
	$HUI.combobox("#DDCPSType",{
		data:PageLogicObj.PartType,
		valueField:"id",
		textField:"desc"	
	})
}

function Init()
{
	var CurePartSetColumns=[[  
		{ field: 'CPSRowid', title: 'ID', width: 1,hidden:true
		}, 
		{ field: 'CPSTypeid', title: 'CPSTypeid', width: 1,hidden:true
		}, 
		{ field: 'CPSType', title:'类型', width: 200, sortable: true  
		},
		{ field: 'CPSCode', title:'代码', width: 200, hidden: true  
		},
		{ field: 'CPSDesc', title: '描述', width: 300, sortable: true
		},
		{ field: 'CPSAlias', title: '别名', width: 300, sortable: true
		},
		{ field: 'CPSDefaultFlag', title: '默认', width: 100,
			formatter:function(value,row,index){
				if (value == "是") {
					return "<span class='fillspan'>"+value+"</span>";
				}else {
					return value;
				}
			}
		},
		{ field: 'CPSActiveFlag', title: '激活', width: 100
		}
	]];
	var CurePartSetDataGrid=$("#tabCurePartSet").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPartSetConfig&rows=9999",
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"CPSRowid",
		pageSize: 25,
		pageList : [25,50,100],
		columns :CurePartSetColumns,
		//toolbar:CurePartSetToolBar,
		onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var UserHospID=GetUserHospID();
			var SDesc=$("#SDesc").searchbox("getValue");
			$.extend(param,{SDesc:SDesc,HospID:UserHospID});
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       },onClickRow:function(rowIndex, rowData){
	   		var collapsed=$('#main-layout').layout('panel', 'east').panel('options').collapsed
			if (rowData.CPSType=="穴位"){
				if (collapsed){
					$("#main-layout").layout('expand','east');
				}
				$(".table-set .table-set-filed").removeAttr("disabled");
				$('.table-set .hisui-filebox').filebox('enable');
				$('.table-set .hisui-linkbutton').linkbutton('enable');
				SetAcupDetail(rowData.CPSRowid);
			}else{
				if (!collapsed){
					$("#main-layout").layout('collapse','east');
				}
				$(".table-set .table-set-filed").attr("disabled","disabled");
				$('.table-set .hisui-filebox').filebox('disable');
				$('.table-set .hisui-linkbutton').linkbutton('disable');
				SetAcupDetail(rowData.CPSRowid);
			}
		}
	});
	return CurePartSetDataGrid;
}

function CurePartSetDataGridLoad()
{
	PageLogicObj.CurePartSetDataGrid.datagrid("reload");
};

function CheckData(){
	var DDCPSType=$("#DDCPSType").combobox("getValue");
	if(DDCPSType=="")
	{
		$.messager.alert("提示", "类型不能为空", 'warning', function(){
			$('#DDCPSType').next('span').find('input').focus();
		})
        return false;
	}
	/*var DDCPSCode=$("#DDCPSCode").val();
	if(DDCPSCode=="")
	{
		$.messager.alert("提示", "代码不能为空", 'warning')
        return false;
	}*/
	var DDCPSDesc=$("#DDCPSDesc").val();
	if(DDCPSDesc=="")
	{
		$.messager.alert('提示','描述不能为空', 'warning', function(){
			$("#DDCPSDesc").focus();
		});   
        return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
	if(!CheckData()) return false;    
	var DDCPSROWID=$("#DDCPSROWID").val();
	var DDCPSType=$("#DDCPSType").combobox("getValue");
	var DDCPSCode=""; //$("#DDCPSCode").val();
	var DDCPSDesc=$("#DDCPSDesc").val();
	var DDCPSAlias=$("#DDCPSAlias").val();
	var DDCPSDefaultFlag=$("#DDCPSDefaultFlag").checkbox("getValue");
	DDCPSDefaultFlag=(DDCPSDefaultFlag==true?"Y":"N");
	var DDCPSAvailFlag=$("#DDCPSAvailFlag").checkbox("getValue");
	DDCPSAvailFlag=(DDCPSAvailFlag==true?"Y":"N");
	var InputPara=DDCPSROWID+"^"+DDCPSType+"^"+DDCPSCode+"^"+DDCPSDesc+"^"+DDCPSDefaultFlag+"^"+DDCPSAvailFlag+"^"+DDCPSAlias;
	//alert(InputPara)
	var UserHospID=GetUserHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		MethodName:"SaveCurePartSet",
		SetPara:InputPara,
		HospID:UserHospID
	},function testget(value){
		if(value.indexOf("^")>-1){
			var valueAry=value.split("^");
			var ID=valueAry[1];
			value=valueAry[0];
		}
		if(value=="0"){
			$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
			$("#add-dialog").dialog( "close" );
			CurePartSetDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else if (value=="101") err="该部位描述已存在";
			else err=value;
			$.messager.alert('提示',err,"warning");   
			return false;
		}
	});
}
function AddGridData(){
	$("#add-dialog").dialog("open");
	$('#add-form').form("clear")	
}
///修改表格函数
function UpdateGridData(){
	var row = PageLogicObj.CurePartSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartSetDataGrid.getSelections();
    if ((!row)||(row.length==0)){
	    $.messager.alert("提示","请选择一行需要修改的记录！",'warning')
	    return false;
    }else{
		$('#add-dialog').window('open');
        //清空表单数据
	 	$('#add-form').form("clear");
	 	var DefaultFlag=(row.CPSDefaultFlag=="是"?true:false);
	 	var ActiveFlag=(row.CPSActiveFlag=="是"?true:false);
	 	
		$("#DDCPSDefaultFlag").checkbox("setValue",DefaultFlag);
		$("#DDCPSAvailFlag").checkbox("setValue",ActiveFlag);
		$("#DDCPSType").combobox("setValue",row.CPSTypeid);
		
		$('#add-form').form("load",{
			DDCPSROWID:row.CPSRowid,
			DDCPSCode:row.CPSCode,
			DDCPSDesc:row.CPSDesc,
			DDCPSAlias:row.CPSAlias	 
		})
		return true;
     }
}

function GetUserHospID(){
	var UserHospID=$HUI.combogrid('#_HospUserList').getValue();
	return UserHospID
}

function ReHospitalHandle(){
	var row=PageLogicObj.CurePartSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！","warning")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCure_PartSet",row["CPSRowid"])
}

function SaveAcupDetail(){
	var row = PageLogicObj.CurePartSetDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择部位/穴位！",'warning')
	}else{
	    var PartId=row.CPSRowid;
		var AcupPosition=$("#AcupPosition").val();
		var AcupAttending=$("#AcupAttending").val();
		var AcupOperation=$("#AcupOperation").val();
		var FileObj =$HUI.filebox("#AcupImgDiagram").files();
		var FilePath=FileObj[0];
		if(((!FilePath)||(typeof(FilePath)=="undefined")) 
		&& (AcupPosition=="")
		&& (AcupAttending=="")
		&& (AcupOperation=="")){
			//$.messager.alert("提示","要保存什么？",'warning')
			//return;
		}
		
		var AcupObj = {};
		AcupObj["AcupPosition"] = AcupPosition;
		AcupObj["AcupAttending"] = AcupAttending;
		AcupObj["AcupOperation"] = AcupOperation;
		var AcupJson = JSON.stringify(AcupObj);
		var FileObj =$HUI.filebox("#AcupImgDiagram").files();
		var PicObj=$HUI.filebox("#AcupImgDiagram");
		var FilePath=FileObj[0];
		if((!FilePath)||(typeof(FilePath)=="undefined")){
			Save(PartId,AcupJson,"");
	    }else{
			com_Util.convertImgToBase64(FilePath,function(base64Img,picobj){
		    	if(base64Img!=""){
			    	Save(PartId,AcupJson,base64Img);
		    	}else{
			    	$.messager.alert("提示","图解格式转换错误!",'warning');
			    	return false;
			    }
		    },PicObj);    
		}
	}
	
	function Save(PartId,AcupJson,ImgDiagram){
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.BodySet",
			MethodName:"AcupDetailSet",
			PartId:PartId,
			AcupJson:AcupJson,
			ImgDiagram:ImgDiagram,
			dataType:"text"
		},function(ret){
			if(ret=="0"){
				$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
				if(ImgDiagram!=""){ImageShowHandle(ImgDiagram);}
			}else{
				$.messager.alert("提示","保存失败:"+ret,'warning')	
			}	
		})	
	}
}

function ClearAcupDetail(){
	var collapsed=$('#main-layout').layout('panel', 'east').panel('options').collapsed;
	if (!collapsed){
		$("#main-layout").layout('collapse','east');
	}
	$("#AcupPosition,#AcupAttending,#AcupOperation").val("");
	ImageShowHandle("");
	$("#AcupImgDiagram").filebox('clear');	
}

function SetAcupDetail(CPSRowid){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		MethodName:"GetAcupDetail",
		PartId:CPSRowid
	},function(ret){
		if(typeof(ret)=="object"){
			$("#AcupPosition").val(ret.AcupPosition);
			$("#AcupAttending").val(ret.AcupAttending);
			$("#AcupOperation").val(ret.AcupOperation);
			ImageShowHandle(ret.AcupImgDiagramShow);
			$("#AcupImgDiagram").filebox('clear');
		}else{
			$.messager.popover({msg: '穴位属性数据获取异常',type:'alert',timeout: 1000});
		}
	})		
}

function DelAcupImgDiagram(){
	var row = PageLogicObj.CurePartSetDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择部位/穴位!",'warning')
	}else{
		if($("#AcupImgDiagramShow").attr("src")==""){
			$.messager.alert("提示","暂无图解.",'warning')
			return;	
		}
		$.messager.confirm("提示","是否确认删除图解?",function(r){
			if(r){
				var PartId=row.CPSRowid;
				var AcupPosition=$("#AcupPosition").val();
				$.cm({
					ClassName:"DHCDoc.DHCDocCure.BodySet",
					MethodName:"DelAcupImgDiagram",
					PartId:PartId,
					dataType:"text"
				},function(ret){
					if(ret=="0"){
						$.messager.popover({msg: '删除成功',type:'success',timeout: 1000});
						ImageShowHandle("");
					}else{
						$.messager.alert("提示","删除失败:"+ret,'warning')	
					}	
				})	
			}	
		})
	}
}
function ImageShowHandle(src){
	$("#AcupImgDiagramShow").unbind();
	if(src==""){
		$("#AcupImgDiagramShow").attr("src","");
		$("#AcupImgDiagramShow").attr("title","");	
	}else{
		$("#AcupImgDiagramShow").attr("src",src);
		$("#AcupImgDiagramShow").attr("title","点击图片查看大图");
		$("#AcupImgDiagramShow").bind("click",function(){
			showImage(this)	
		})
	}
}

function showImage(that) {
	//alert(e.id+","+e.src);
	if(typeof(that.src)=="undefined"){
		that.src=that.id;	
	}
	if(that.src==""){
		return	
	}
	const img = new Image();
	img.src = that.src;
	const newWin = window.open("", "_blank","height=600,width=1000,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,top=50,left=50");
	newWin.document.write(img.outerHTML);
	newWin.document.title = "图片详情"
	newWin.document.close();
}

function Import(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=DHCDoc.DHCDocCure.OnlineSupport&mMethodName=ImportCurePartExcel&sheetType=JSON&NotShowDetail=Y";
	var $code ="<iframe width='100%' height='98%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	com_Util.createModalDialog("importDiag","导入", 600, 240,"icon-w-import","",$code,"");
}