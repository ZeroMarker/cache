//20181219+dyl
var bpBERowId;
var selectBpIndex;

$(function(){
	InitFormItem();
	InitGroupData();
});
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
function InitFormItem()
{
	$HUI.datebox("#bpdstartDate",{
	})
	$HUI.datebox("#bpdendDate",{
	})
	$HUI.datebox("#winSamplingDate",{
	})
	var date=new Date();
	var fromDay = date.getDate()+"/"+(date.getMonth()-2)+"/"+date.getFullYear();
	$("#bpdstartDate").datebox("setValue",fromDay);
	var toDay = date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
	$("#bpdendDate").datebox("setValue",toDay);
	var winSampleNameObj=$HUI.combobox("#winSampleName",{
		url:$URL+"?ClassName=web.DHCBPCDetection&QueryName=FindBPCDetection&ResultSetType=array",
		valueField:'tRowId',
		textField:'BPCDDesc',
		onHidePanel: function () {
        	OnHidePanel("#winSampleName");
        },
		})
		
	var winSampleNoObj=$HUI.combobox("#winSampleNo",{
		url:$URL+"?ClassName=web.DHCBPBedEquip&QueryName=FindBedEquip&ResultSetType=array",
		valueField:'tBPBEBPCEquipDr',
		textField:'tBPBEBPCEquip',
		panelHeight:'auto',
		onHidePanel: function () {
        	OnHidePanel("#winSampleNo");
        },
		})
	var logonCtlocId=session['LOGON.CTLOCID'];
	//�μ���Ա
	$HUI.combobox("#winParticipants",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindUserByLoc&ResultSetType=array",
        valueField:"Id",
        textField:"Name",
        //panelHeight:'auto',
        onBeforeLoad:function(param)
        {
	        param.locId=logonCtlocId;
        },
        onHidePanel: function () {
        	OnHidePanel("#winParticipants");
        },   
    });	
    
    $HUI.combobox("#winIsQualified",{
		    valueField:"Id",
		    textField:'Desc',
		    panelHeight:'auto',
			data:[
			{Id:"1",Desc:"�ϸ�"},
			{Id:"0",Desc:"���ϸ�"}
			],
			onHidePanel: function () {
        		OnHidePanel("#winIsQualified");
        	}, 
	    });
    
	$HUI.combobox("#equipName",{
		url:$URL+"?ClassName=web.DHCBPBedEquip&QueryName=FindBedEquip&ResultSetType=array",
		valueField:'tBPBEBPCEquipDr',
		textField:'tBPBEBPCEquip',
		panelHeight:'auto',
		onHidePanel: function () {
        		OnHidePanel("#equipName");
        },
	})		
		
	$("#findbutton").bind("click",function(){
		var detectionBoxObj=$HUI.datagrid("#detectionListData",{
		url:$URL,
			queryParams:{
			ClassName:"web.DHCBPDetection",
			QueryName:"FindBPDetection",
			startDate:$("#bpdstartDate").datebox('getValue'),
			endDate:$("#bpdendDate").datebox('getValue'),
			equipName:$("#equipName").combobox('getValue'),
			equioSeqNo:$("#equipSeqNo").val(),
		}})
	
	})
	$("#btnExport").click(function(){
        printHandler();
    });
}
function InitGroupData()
{	
	$("#detectionListData").datagrid({
		url:$URL,
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		//checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		//selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,        
        queryParams:{
            ClassName:"web.DHCBPDetection",
            QueryName:"FindBPDetection"
        },
        onBeforeLoad: function(param) {        
	        param.startDate=$("#bpdstartDate").datebox('getValue');
			param.endDate=$("#bpdendDate").datebox('getValue');
			param.equipName=$("#equipName").combobox('getValue');
			param.equioSeqNo=$("#equipSeqNo").val();
        },
        columns:[[
		{field:"tRowId",title:"ϵͳ��",width:80}
		,{field:"tBPCDetectionDesc",title:"�����Ʒ����",width:150}
		,{field:"tBPDBPCEquip",title:"�豸��",width:150}
		,{field:"tBPDSpecimenNo",title:"��Ʒ����",width:150}
		,{field:"tBPDDate",title:"����ʱ��",width:100}
		,{field:"IsQualified",title:"�Ƿ�ϸ�",width:100}
		,{field:"userNameList",title:"�μ���",width:100}
		,{field:"tBPDNote",title:"��ע(���ϸ�ԭ��)",width:150}
		,{field:"tDBPDEquipSeqNo",title:"�豸���к�",width:120}
		,{field:"tBPCDetectionDr",hidden:true}
		,{field:"tBPDBPCEquipCode",hidden:true}
		,{field:"tBPDIsQualified",hidden:true}
		,{field:"userIdList",hidden:true}		
		]],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'����',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'�޸�',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'ɾ��',
			    handler: function(){
                    deleteRow();
                }
            },
           	{
				iconCls:"icon-print",
				text:"����",
				handler:function(){
					printHandler();
				}
			}
        ],
        onSelect:function(rowIndex, rowData){
	        selectBpIndex=rowIndex;
	        bpBERowId=rowData.tRowId;
	        
        }
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#detectionListData").reload();
    });
}
function deleteRow()
{
var selectRow=$("#detectionListData").datagrid("getSelected");
    if(selectRow)
    {	    
	    var datas=$.m({
        ClassName:"web.DHCBPDetection",
        MethodName:"DeleteBPDetection",
        rowid:selectRow.tRowId,
    },false);
    if(datas==0)
    {
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#detectionListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'error');
        return;
    }	
}
function InitBPDiag()
{
	$("#winSampleName").combobox('setValue',"");
	$("#winSampleNo").combobox('setValue',"");
	$("#winSamplingDate").datebox('setValue',"");
	$("#winIsQualified").combobox('setValue',"");
	$("#winParticipants").combobox('setValue',"");
	$("#winSpecimenNo").val("");
	$("#winNote").val("");	
}
//����
function appendRow()
{
	    $("#detectionDlg").dialog({
        title: "������������ά��",
        iconCls: "icon-w-add"
    });
    InitBPDiag();
    $("#detectionDlg").dialog("open");

}
function saveDetect()
{

	var sampleName=$("#winSampleName").combobox('getValue');
	var sampleNameDesc=$("#winSampleName").combobox('getText');
	var sampleNo=$("#winSampleNo").combobox('getValue');
	var sampleNoDesc=$("#winSampleNo").combobox('getText');
	var samplingDate=$("#winSamplingDate").datebox('getValue');
	var specimenNo=$("#winSpecimenNo").val();
	var note=$("#winNote").val();
	var isQualified=$("#winIsQualified").combobox('getValue');
	var isQualifiedDesc=$("#winIsQualified").combobox('getText');
	var participants=$("#winParticipants").combobox('getValue');
	var participantsDesc=$("#winParticipants").combobox('getText');
	var userId=session['LOGON.USERID'];
	if((participants=="")||(participants==undefined)){
		$.messager.alert("��ʾ","�μ��˲���Ϊ��","error");
		return;
	}
    var rowdata={
	    tBPCDetectionDr:sampleName,
	    tBPCDetectionDesc:sampleNameDesc,
        tBPDBPCEquipCode:sampleNo,
        tBPDBPCEquip:sampleNoDesc,
        tBPDSpecimenNo:specimenNo,
        tBPDDate:samplingDate,
    	tBPDIsQualified:isQualifiedDesc,
    	IsQualified:isQualified, 
    	userIdList:participants,   
    	userNameList:participantsDesc,       
        tBPDNote:note,
    } 
    	    	
    if($("#EditDetection").val()=="Y")
    {
    	var datas=$.m({
        ClassName:"web.DHCBPDetection",
        MethodName:"UpdateBPDetection",
        BPDetectionInfo:bpBERowId+"^"+sampleName+"^"+sampleNo+"^"+samplingDate+"^"+""+"^"+specimenNo+"^"+note+"^"+userId+"^"+""+"^"+""+"^"+isQualified+"^"+""+"^"+participants
    	},false);
    	if (datas==0)
    	{
    		$HUI.datagrid("#detectionListData").updateRow({index:selectBpIndex,row:rowdata});
    		$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }	    
    }
    else
    {
    	var datas=$.m({
        ClassName:"web.DHCBPDetection",
        MethodName:"InsertBPDetection",
        BPDetectionInfo:sampleName+"^"+sampleNo+"^"+samplingDate+"^"+""+"^"+specimenNo+"^"+note+"^"+userId+"^"+""+"^"+""+"^"+isQualified+"^"+""+"^"+participants,		
    	},false);
    	if (datas==0)
    	{
    		$HUI.datagrid("#detectionListData").appendRow(rowdata);
    		$.messager.alert("��ʾ", "�����ɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }
    }
    $("#detectionListData").datagrid("reload");
	$HUI.dialog("#detectionDlg").close();
	$("#EditDetection").val("");
}
function editRow()
{
	var selectRow=$("#detectionListData").datagrid("getSelected");
    if(selectRow)
    {
        $("#detectionDlg").dialog({
            title: "�޸�����������Ϣ",
            iconCls: "icon-w-edit"
        });
        $("#winSampleName").combobox('setValue',selectRow.tBPCDetectionDr);	
		$("#winSampleNo").combobox('setValue',selectRow.tBPDBPCEquipCode);
		$("#winSpecimenNo").val(selectRow.tBPDSpecimenNo);
		$("#winSamplingDate").datebox('setValue',selectRow.tBPDDate);
		$("#winIsQualified").combobox('setValue',selectRow.tBPDIsQualified);
		$("#winParticipants").combobox('setValue',selectRow.userIdList);	
		$("#winNote").val(selectRow.tBPDNote);    
        
        $("#detectionDlg").window("open");
        $("#EditDetection").val("Y");
        
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'error');
        return;
    }

	
}

function GetFilePath()
	{
		var path=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetPath"
    },false);
    return path;
}
var printHandler=function(){
		LODOP=getLodop();			
		var htmlStr="<div>"	
		htmlStr+="<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000' style='border-collapse:collapse;'>"		
		htmlStr+="<thead>"		
	    htmlStr+="<tr>"
		htmlStr+="<td height='40' align='center' colspan='4' style='border:solid 0px'><b><font size='5'>"+"͸��Һ������ˮ"+"</b></td>"
		htmlStr+="<td height='40' align='center' colspan='4' style='border:solid 0px'><b><font size='5'>"+"�ʿؼ�¼"+"</b></td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<th width='90' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>���</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>�����Ʒ���ơ����</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>����豸</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>��Ʒ����</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>����ʱ��</font></th>"
		htmlStr+="<th width='100' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>�Ƿ�ϸ�</font></th>"
		htmlStr+="<th width='120' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>�μ���</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>��ע�����ϸ�ԭ��</font></th>"		
		htmlStr+="</tr>"
		htmlStr+="</thead>"	
		htmlStr+="<tbody>"				
		var rows=$("#detectionListData").datagrid("getRows");
		for(var i=0;i<rows.length;i++){
			htmlStr+="<tr>"
			htmlStr+="<td style='border:solid 1px'>"+i+1+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPCDetectionDesc+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPDBPCEquip+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPDSpecimenNo+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPDDate+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].IsQualified+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].userNameList+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPDNote+"</td>"
			htmlStr+="</tr>"
		}
		htmlStr+="</tbody>"		
		htmlStr+="</table>" 
		htmlStr+="</div>"
		LODOP.PRINT_INIT("�ʿؼ�¼")
		LODOP.SET_SAVE_MODE("Orientation",1) //Excel�ļ���ҳ�����ã������ӡ   1-����,2-����;
		LODOP.SET_SAVE_MODE("PaperSize",9)  //Excel�ļ���ҳ�����ã�ֽ�Ŵ�С   9-��ӦA4
		LODOP.ADD_PRINT_TABLE(1,1,1000,300,htmlStr)
		LODOP.SAVE_TO_FILE("�ʿؼ�¼.xls")
}	
var printHandlerBak=function(){
	
	var xlgendercel
	var xlsBook
	var xlsSheet
	var path=GetFilePath();

		path = path.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCBPDetection.xlsx";
        xlgendercel = new ActiveXObject("Excel.Application");
        xlsBook = xlgendercel.Workbooks.Add(path);
        xlsSheet = xlsBook.ActiveSheet;
		var rows=$("#detectionListData").datagrid("getRows");
		var j=0;
		for(var i=0;i<rows.length;i++){
		    j=i+3;
			xlsSheet.Range("A"+j).Value=rows[i].tRowId;
			xlsSheet.Range("B"+j).Value=rows[i].tBPCDetectionDesc;
			xlsSheet.Range("C"+j).Value=rows[i].tBPDBPCEquip;
			xlsSheet.Range("D"+j).Value=rows[i].tBPDSpecimenNo;
			xlsSheet.Range("E"+j).Value=rows[i].tBPDDate;
			xlsSheet.Range("F"+j).Value=rows[i].IsQualified;
			xlsSheet.Range("G"+j).Value=rows[i].userNameList;
			xlsSheet.Range("H"+j).Value=rows[i].tBPDNote;
			
		}
		xlgendercel.Visible = true;
		//var savefileName="D:\\�ʿؼ�¼.xls"
		//xlsSheet.SaveAs(savefileName);
		//alert("�ļ��ѵ��뵽"+savefileName);
	    //xlsSheet=null;
	    //xlsBook.Close(savechanges=false);
	    //xlsBook=null;	
	//xlgendercel.Quit();
	//xlgendercel=null;
}

