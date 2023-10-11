var PageLogicObj={
	CurePartSetDataGrid:"",
	PartType:[{id:"BP",desc:"��λ"},{id:"A",desc:"Ѩλ"}]
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
		{ field: 'CPSType', title:'����', width: 200, sortable: true  
		},
		{ field: 'CPSCode', title:'����', width: 200, hidden: true  
		},
		{ field: 'CPSDesc', title: '����', width: 300, sortable: true
		},
		{ field: 'CPSAlias', title: '����', width: 300, sortable: true
		},
		{ field: 'CPSDefaultFlag', title: 'Ĭ��', width: 100,
			formatter:function(value,row,index){
				if (value == "��") {
					return "<span class='fillspan'>"+value+"</span>";
				}else {
					return value;
				}
			}
		},
		{ field: 'CPSActiveFlag', title: '����', width: 100
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
		loadMsg : '������..',  
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
			if (rowData.CPSType=="Ѩλ"){
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
		$.messager.alert("��ʾ", "���Ͳ���Ϊ��", 'warning', function(){
			$('#DDCPSType').next('span').find('input').focus();
		})
        return false;
	}
	/*var DDCPSCode=$("#DDCPSCode").val();
	if(DDCPSCode=="")
	{
		$.messager.alert("��ʾ", "���벻��Ϊ��", 'warning')
        return false;
	}*/
	var DDCPSDesc=$("#DDCPSDesc").val();
	if(DDCPSDesc=="")
	{
		$.messager.alert('��ʾ','��������Ϊ��', 'warning', function(){
			$("#DDCPSDesc").focus();
		});   
        return false;
	}
	return true;
}
///�޸ı����
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
			$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
			$("#add-dialog").dialog( "close" );
			CurePartSetDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="101") err="�ò�λ�����Ѵ���";
			else err=value;
			$.messager.alert('��ʾ',err,"warning");   
			return false;
		}
	});
}
function AddGridData(){
	$("#add-dialog").dialog("open");
	$('#add-form').form("clear")	
}
///�޸ı����
function UpdateGridData(){
	var row = PageLogicObj.CurePartSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartSetDataGrid.getSelections();
    if ((!row)||(row.length==0)){
	    $.messager.alert("��ʾ","��ѡ��һ����Ҫ�޸ĵļ�¼��",'warning')
	    return false;
    }else{
		$('#add-dialog').window('open');
        //��ձ�����
	 	$('#add-form').form("clear");
	 	var DefaultFlag=(row.CPSDefaultFlag=="��"?true:false);
	 	var ActiveFlag=(row.CPSActiveFlag=="��"?true:false);
	 	
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
		$.messager.alert("��ʾ","��ѡ��һ�У�","warning")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCure_PartSet",row["CPSRowid"])
}

function SaveAcupDetail(){
	var row = PageLogicObj.CurePartSetDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��λ/Ѩλ��",'warning')
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
			//$.messager.alert("��ʾ","Ҫ����ʲô��",'warning')
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
			    	$.messager.alert("��ʾ","ͼ���ʽת������!",'warning');
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
				$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
				if(ImgDiagram!=""){ImageShowHandle(ImgDiagram);}
			}else{
				$.messager.alert("��ʾ","����ʧ��:"+ret,'warning')	
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
			$.messager.popover({msg: 'Ѩλ�������ݻ�ȡ�쳣',type:'alert',timeout: 1000});
		}
	})		
}

function DelAcupImgDiagram(){
	var row = PageLogicObj.CurePartSetDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��λ/Ѩλ!",'warning')
	}else{
		if($("#AcupImgDiagramShow").attr("src")==""){
			$.messager.alert("��ʾ","����ͼ��.",'warning')
			return;	
		}
		$.messager.confirm("��ʾ","�Ƿ�ȷ��ɾ��ͼ��?",function(r){
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
						$.messager.popover({msg: 'ɾ���ɹ�',type:'success',timeout: 1000});
						ImageShowHandle("");
					}else{
						$.messager.alert("��ʾ","ɾ��ʧ��:"+ret,'warning')	
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
		$("#AcupImgDiagramShow").attr("title","���ͼƬ�鿴��ͼ");
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
	newWin.document.title = "ͼƬ����"
	newWin.document.close();
}

function Import(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=DHCDoc.DHCDocCure.OnlineSupport&mMethodName=ImportCurePartExcel&sheetType=JSON&NotShowDetail=Y";
	var $code ="<iframe width='100%' height='98%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	com_Util.createModalDialog("importDiag","����", 600, 240,"icon-w-import","",$code,"");
}