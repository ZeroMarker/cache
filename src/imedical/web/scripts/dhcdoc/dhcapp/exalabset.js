var PatType=["O","E","I","H"];
var PageLogicObj={
	DHCLocPrintSetTabDataGrid:"",
	editRow:undefined,
	LocRowID:"",
	PetSetType:""
}
$(function(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Exalabset",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		$HUI.radio(".hisui-radio").setValue(false);
		Init();
	} 
	//��ʼ��
	Init();
	PageLogicObj.DHCLocPrintSetTabDataGrid=InitLocPrintSetTabDataDataGrid();
	//�¼���ʼ��
	InitEvent();
});
function Init(){
	LoadDataList();
}
function InitEvent(){
	$("#BSave").click(SaveClickHandler);
	$("#BSave_LocPrintExa").click(function(){LocPrintSet("E")});
	$("#BSave_LocPrintLab").click(function(){LocPrintSet("L")});
	$("#SentAppionmentAdtip").popover({title:'URLά������',trigger:'hover',content:'Ŀǰ֧�ֵı�����:����ID{PatientID},����ID{EpisodeID},���뵥��{ExaRepNo},ҽ����{OEORDID}'});
}
function LocPrintSet(Type){
	PageLogicObj.Type=Type;
	if(PageLogicObj.Type=="E"){
		var mTitle="���";
	}else if(PageLogicObj.Type=="L"){
		var mTitle="����";
	}
	mTitle=mTitle+"���뵥���Ͳ���ӡ�����������";
	$(".hisui-searchbox").searchbox("setValue","");
	LocPrintSetTabDataGridLoad();
	
	$('#locprintset-dialog').window({
		title:mTitle
	}).window('open');
}

function SaveClickHandler(){
	 var DataList="";
	 var Opentree = $("input[name='DHCAPP_Opentree']:checked").val();
	 if (Opentree==undefined) {Opentree=""}
	 DataList="Opentree"+String.fromCharCode(1)+Opentree;
	 var TreeTypeBody = $("input[name='DHCAPP_TreeTypeBody']:checked").val();
	 if (TreeTypeBody==undefined) {TreeTypeBody=""}
	 DataList=DataList+String.fromCharCode(2)+"TreeTypeBody"+String.fromCharCode(1)+TreeTypeBody;
	 var PrintExa=""
	 if ($("#DHCAPP_PrintExaO").is(":checked")) {
		 PrintExa=PrintExa+",O"
     }
	 if ($("#DHCAPP_PrintExaE").is(":checked")) {
		 PrintExa=PrintExa+",E"
     }
	 if ($("#DHCAPP_PrintExaI").is(":checked")) {
		 PrintExa=PrintExa+",I"
     }
     if ($("#DHCAPP_PrintExaH").is(":checked")) {
		 PrintExa=PrintExa+",H"
     }
     DataList=DataList+String.fromCharCode(2)+"PrintExa"+String.fromCharCode(1)+PrintExa;
     var SetRis=""
	 if ($("#DHCAPP_SetRisO").is(":checked")) {
		 SetRis=SetRis+",O"
     }
     if ($("#DHCAPP_SetRisE").is(":checked")) {
		 SetRis=SetRis+",E"
     }
     if ($("#DHCAPP_SetRisI").is(":checked")) {
		 SetRis=SetRis+",I"
     }
     if ($("#DHCAPP_SetRisH").is(":checked")) {
		 SetRis=SetRis+",H"
     }
     DataList=DataList+String.fromCharCode(2)+"SetRis"+String.fromCharCode(1)+SetRis;
     var PrintLab=""
	 if ($("#DHCAPP_PrintLabO").is(":checked")) {
		 PrintLab=PrintLab+",O"
     }
     if ($("#DHCAPP_PrintLabE").is(":checked")) {
		 PrintLab=PrintLab+",E"
     }
     if ($("#DHCAPP_PrintLabI").is(":checked")) {
		 PrintLab=PrintLab+",I"
     }
     if ($("#DHCAPP_PrintLabH").is(":checked")) {
		 PrintLab=PrintLab+",H"
     }
     DataList=DataList+String.fromCharCode(2)+"PrintLab"+String.fromCharCode(1)+PrintLab;
     var CheckDiag = $("input[name='DHCAPP_CheckDiag']:checked").val();
	 if (CheckDiag==undefined) {CheckDiag="N"}
	 DataList=DataList+String.fromCharCode(2)+"CheckDiag"+String.fromCharCode(1)+CheckDiag;
	 var SentAppionmentAd=$("#DHCAPP_SentAppionmentAd").val()
	 DataList=DataList+String.fromCharCode(2)+"SentAppionmentAd"+String.fromCharCode(1)+SentAppionmentAd;
	 var OpenAppionment = $("input[name='DHCAPP_OpenAppionment']:checked").val();
	 if (OpenAppionment==undefined) {OpenAppionment="N"}
	 DataList=DataList+String.fromCharCode(2)+"OpenAppionment"+String.fromCharCode(1)+OpenAppionment;
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"SavebaseInfo",
	 	DataList:DataList,
	 	HospId:HospID
		},false);
	if (value==0){
		$.messager.popover({msg: '����ɹ�!',type:'success'});
		LoadDataList();
	}else{
		$.messager.alert("��ʾ", "����ʧ��"+value, "error");
        return false;	
		}	
}
function LoadDataList(){
	GetRadioValue("Opentree")
	GetRadioValue("TreeTypeBody")
	GetRadioValue("CheckDiag")
	GetRadioValue("OpenAppionment")
	GetCheckPatTypeValue("PrintExa")
	GetCheckPatTypeValue("SetRis")
	GetCheckPatTypeValue("PrintLab")
	GetTextValue("SentAppionmentAd")
}
function GetCheckPatTypeValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	for (var i = 0; i < PatType.length; i++) {
		var subnote=PatType[i]
		if (subnote!=""){
			$HUI.checkbox("#DHCAPP_"+Node+subnote).setValue(false);	
		}
	}
	if (value!=""){
	var valueArr=value.split(",")
	for (var i = 0; i < valueArr.length; i++) {
		var subnote=valueArr[i]
		if (subnote!=""){
			$HUI.checkbox("#DHCAPP_"+Node+subnote).setValue(true);
			}
		}
	}
	}
function GetTextValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	$("#DHCAPP_"+Node).val(value)
}
function GetCheckValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value=="1"){
		$HUI.checkbox("#DHCAPP_"+Node).setValue(true);
		}else{
		$HUI.checkbox("#DHCAPP_"+Node).setValue(false);
		}
	}
function GetRadioValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value!=""){
		$HUI.radio("#"+value).setValue(true);
		}
	}

function InitLocPrintSetTabDataDataGrid(){
	var Columns=[[ 
		{field:'LocRowID',title:'LocRowID',hidden:true,width:10},
		{field:'LocDesc',title:'��������',width:400},
		{field:'LocPrintSetO',title:'����',width:150,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           },
           styler: function(value,row,index){
 				if (value=="1"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   },
 		   formatter:function(value,record){
	 			if (value=="1") return "��";
	 			else if (value=="0") return "��";
	 			else  return "";
	 	   }
        },
		{field:'LocPrintSetE',title:'����',width:230,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           },
           styler: function(value,row,index){
 				if (value=="1"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   },
 		   formatter:function(value,record){
	 			if (value=="1") return "��";
	 			else if (value=="0") return "��";
	 			else  return "";
	 	   }
        },
		{field:'LocPrintSetI',title:'סԺ',width:230,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           },
           styler: function(value,row,index){
 				if (value=="1"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   },
 		   formatter:function(value,record){
	 			if (value=="1") return "��";
	 			else if (value=="0") return "��";
	 			else  return "";
	 	   }
        },
		{field:'LocPrintSetH',title:'���',width:230,align:'center',editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : ''
                }
           },
           styler: function(value,row,index){
 				if (value=="1"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   },
 		   formatter:function(value,record){
	 			if (value=="1") return "��";
	 			else if (value=="0") return "��";
	 			else  return "";
	 	   }
        }
    ]]
    var LocToolBar = [{
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            SaveLocPrtSet();
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                PageLogicObj.editRow = undefined;
                PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("rejectChanges");
                PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("unselectAll");
            }
        }];
	var DHCLocPrintSetTabDataGrid=$("#DHCLocPrintSetTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,
		pageSize: 20,
		pageList : [20,100,200],
		idField:'LocRowID',
		columns :Columns,
		toolbar :LocToolBar,
		onLoadSuccess:function(data){
			PageLogicObj.editRow=undefined;
			PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("unselectAll")
		},
		onClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
		        return false;
			}
			PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex
			PageLogicObj.LocRowID=rowData.LocRowID
		}
	}); 
	return DHCLocPrintSetTabDataGrid;
}
	
function LocPrintSetTabDataGridLoad(){
	var Loc=$("#desc").searchbox("getValue");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "DHCDoc.DHCApp.BasicConfig",
	    QueryName : "GetLocPrtConfig",
	    desc : Loc,
	    HospId:HospID,
	    Type:PageLogicObj.Type,
	    Pagerows:PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 	
}

function SaveLocPrtSet(){
	if(PageLogicObj.LocRowID=="" || PageLogicObj.editRow==undefined){
		return false;
	}
	var rows = PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("getRows"); 
	var ValAry=new Array();
	if (rows.length > 0)
	{ 	
		for (var i = 0; i < rows.length; i++) {
			if(PageLogicObj.editRow==i){
				var rows=PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
				var editors = PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid('getEditors', PageLogicObj.editRow); 
				var selected=editors[0].target.is(':checked');
				if(selected) ValAry.push("O");
				var selected=editors[1].target.is(':checked');
				if(selected) ValAry.push("E");
				var selected=editors[2].target.is(':checked');
				if(selected) ValAry.push("I");
				var selected=editors[3].target.is(':checked');
				if(selected) ValAry.push("H");
			}
		}
		var ValStr="";
		if(ValAry.length>0){
			ValStr=ValAry.join(",")	
		}
		$.m({
			ClassName:"DHCDoc.DHCApp.BasicConfig",
			MethodName:"SaveConfig1",
			Node:"LocPrtSet",
			Node1:PageLogicObj.LocRowID+"_"+PageLogicObj.Type,
			NodeValue:ValStr
		},function(value){
			if(value=="0"){
				PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("endEdit", PageLogicObj.editRow);
				LocPrintSetTabDataGridLoad();
				$.messager.popover({type:"success",msg:"����ɹ�"});
			}else{
				$.messager.alert('��ʾ',"����ʧ��:"+value);
				return false;
			}
		});
	}
}