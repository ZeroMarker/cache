var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
$(function(){

    initConditionFormControls();
    initOperationGrid();
    
});

//��ʼ�����ؼ�
function initConditionFormControls(){
	$HUI.datebox("#DateFrom",{})
	$HUI.datebox("#DateTo",{})
    var patWard=$HUI.combobox("#PatWard",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=GetWard&ResultSetType=array",
        valueField:"rw",
        textField:"desc",
        onBeforeLoad:function(param)
        {
            param.code=param.q;
        }
    });
    var operStat=$HUI.combobox("#OperStat",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=LookUpComCode&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        onBeforeLoad:function(param)
        {
            param.type="OpaStatus";
        }
    });

    var operRoom=$HUI.combobox("#OperRoom",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
        valueField:"oprId",
        textField:"oprDesc",
        panelHeight:'auto',
        onBeforeLoad:function(param)
        {
            param.oprDesc=param.q;
            param.locDescOrId="";
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID="";
            param.opaId="";
            param.oprBedType="T";
            param.appLocDescOrId="";
        }
    });
    var dateFrom=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDate",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
        var dateTo=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDateOld",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
    $("#DateFrom").datebox('setValue',dateFrom);
    $("#DateTo").datebox('setValue',dateTo);

    $("#btnSearch").click(function(){
        $HUI.datagrid("#OperListBox").load();
    }); 
    $("#btnExport").click(function(){
        ExportCDD();
    }); 
}
//��ʼ�������б�
function initOperationGrid(){
    
    var operList=$HUI.datagrid("#OperListBox",{
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 100,
        pageList: [50, 100, 200],
        checkbox: true,
        headerCls:'panel-header-gray',
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANControlledDrug",
            QueryName:"GetAnestHISUIList"
        },
        onBeforeLoad:function(param)
        {
            param.stdate=$("#DateFrom").datebox('getValue');
            param.enddate=$("#DateTo").datebox('getValue');
            param.stat=$("#OperStat").combobox('getValue');
            param.OpRoom=($("#OperRoom").combobox('getText')=="")?"":$("#OperRoom").combobox('getValue');
            param.userLocId=logLocId;
            param.MedCareNo=$("#MedCareNo").val();
            param.patWardId=$("#PatWard").combobox('getValue');
            param.LogUserType=getLogUserType();
            param.RegNo=$("#RegNo").val();
            param.OpaId=$("#opaId").val();
        },
        onClickRow: function(rowIndex, rowData) {
			opaId = rowData["opaId"];
			$('#OperListBox').datagrid('clearSelections');
			$('#OperListBox').datagrid('selectRow',rowIndex);
		}
		,toolbar:[{     
	                iconCls: 'icon-regdrug',
	                text:'����ҩ�Ǽ�', 
	                handler: function(){
	                     AddFData();
	                	}
	    			}
	    			],
        columns: [
            [
                { field: "opdate", title: "ʹ������", width: 120 },
                { field: "comOpRoom", title: "������", width: 60 },
                { field: "regNo", title: "�ǼǺ�", width: 100 },
                { field: "patName", title: "��������", width: 100 },
                { field: "gender", title: "�Ա�", width: 40 },
                { field: "PatientID", title: "����", width: 40 },
                { field: "PDVAnumber", title: "���֤���", width: 100 },
                { field: "DrugDesc", title: "ҩƷ����", width: 105 },
                { field: "Specification", title: "���", width: 60 },
                { field: "Unit", title: "��λ", width: 40 },
                { field: "Quantity", title: "����", width: 40 },
                { field: "BatchNo", title: "����", width: 80 },
                { field: "orderdoctor", title: "����ҽʦ", width: 60 },
                { field: "usecount", title: "��ҩ��", width: 50 },
                { field: "DisposalMeasures", title: "����ҩҺ���ô�ʩ", width: 60 },
                 { field: "Handler", title: "ִ����", width: 60 },
                { field: "Reviewer", title: "������", width: 65 },
                { field: "Recipient", title: "�հ�곻���(������)", width: 60 },
                { field: "diag", title: "�ٴ����", width: 80 },
                { field: "Note", title: "��ע", width: 100 },
                { field: "opaId", title: "opaId", width: 60 }
             
            ]                
        ],
        onSelect:function(index,data){
            //$("#patient-toolbar").find(".content").html(data.patname+" / "+data.gender+" / "+data.age+" / "+data.regno);
        },
		handler:function(){ //���ܸı��ֵ
        $("#OperListBox").datagrid('acceptChanges');
        },
		onBeforeEdit:function(rowIndex,rowData){
			var logLocType=getLogLocType();
			if(logLocType!="OP")
			{
				return false;
			}
		}
    });
}	
var ANCDRowId="",orderDocId="",orderDoc="";
function InitForm()
{
	var drug=$HUI.combobox("#Drug",{
        url:$URL+"?ClassName=web.DHCANControlledDrug&QueryName=FindDrugList&ResultSetType=array",
        valueField:"drugId",
        textField:"drugDesc",
        onBeforeLoad:function(param)
        {
            param.opaId=opaId;
        },
         onSelect:function(record)
        {
	        orderDoc=record.orderDoc;
	        orderDocId=record.orderDocId;
	        //alert(record.orderDocId)
        },
        onHidePanel: function () {
               OnHidePanel("#Drug");
            },
         mode:'remote'
    })
    	var ctcp=$HUI.combobox("#Handler,#ReChecker,#Reciever",{
        url:$URL+"?ClassName=web.UDHCANOPArrange&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        editable:false,
        onBeforeLoad:function(param)
        {
            param.needCtcpDesc=param.q;
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.locDescOrId=logLocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            param.ifDayOper="";
            param.operId="";
        },
         onSelect:function()
        {
	        //$("#patientLoc").combobox('setValue',"");
        },
        mode:'remote'
    })
    $("#Uom,#Unit").combobox({
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindUomList&ResultSetType=array",
		valueField:"Id",
		textField:"Desc",
		panelWidth:100,
		defaultFilter:1  
	})
       //�¼�
	var drugList=$HUI.datagrid("#drugList",{
        fit:true,
        singleSelect: true,
        rownumbers: true,
         headerCls:'panel-header-gray',
         //showHeader:false,
         url:$URL,
        queryParams:{
            ClassName:"web.DHCANControlledDrug",
            QueryName:"FindDrugInfoList"
        },
        onBeforeLoad:function(param)
        {
            param.opaId=opaId;
        },
        onClickRow: function(rowIndex, rowData) {
	        selectedIndex=rowIndex;
	       	//$HUI.combobox("#Operation").setValue(rowData.Operation);
      		ANCDRowId=rowData["ANCDRowId"]
      		$('#Drug').combobox("setValue",rowData["drugId"]);
			$('#Handler').combobox("setValue",rowData["HandlerId"]);
			$('#ReChecker').combobox("setValue",rowData["ReCheckId"]);
			$('#Reciever').combobox("setValue",rowData["RecipientId"]);
			$("#Uom").combobox("setValue",rowData["UomId"]);
			$("#Unit").combobox("setValue",rowData["UnitId"]);
			$("#BatchNo").val(rowData["BatchNo"]);
		    $("#Quantity").val(rowData["Quantity"]);
		    $("#Volume").val(rowData["usecount"]);
		    $("#DisposalMeasures").val(rowData["DisposalMeasures"]);
		    $("#Note").val(rowData["Note"]);

        },
        toolbar:"#operationTool",
        columns: [
            [
            	{ field: "ANCDRowId", title: "ANCDRowId", width: 40,hidden:true },
                { field: "drugDesc", title: "ҩ������", width: 188 },
                { field: "BatchNo", title: "����", width: 120 },
                { field: "Quantity", title: "����", width: 50 },
                { field: "Unit", title: "��λ", width: 50 },
                { field: "UnitId", title: "��λId", width: 50,hidden:true },
                { field: "usecount", title: "��ҩ��", width: 70 },
                { field: "Uom", title: "��λ", width: 50 },
                { field: "UomId", title: "��λId", width: 50,hidden:true },
                { field: "DisposalMeasures", title: "��Һ����", width: 100 },
                { field: "OrderDoc", title: "����ҽʦ", width: 70 },
                { field: "Handler", title: "ִ����", width: 70 },
                { field: "ReChecker", title: "������", width: 70 },
                { field: "Recipient", title: "�հ�곻�����", width: 100 },
                { field: "Note", title: "��ע", width: 128 },
                { field: "drugId", title: "id", hidden: true },
                {field: "OrderDocId", title: "����ҽʦId", width: 1, hidden: true },
                {field: "HandlerId", title: "��������Id", width: 1, hidden: true },
                {field: "ReCheckId", title: "ReCheckId", width: 1, hidden: true },
                {field: "RecipientId", title: "RecipientId", width: 1, hidden: true }
         ]
        ]
    });
  $("#btnAddDrug").linkbutton({
        onClick: addDrug
    });

    $("#btnEditDrug").linkbutton({
        onClick: editDrug
    });

    $("#btnDelDrug").linkbutton({
        onClick: removeDrug
    });
}

function InitOperDiag()
{
	InitForm();
	$('#Drug').combobox("reload");
	$('#Handler').combobox("reload");
	$('#ReChecker').combobox("reload");
	$('#Reciever').combobox("reload");
	$("#BatchNo").val("");
    $("#Quantity").val("");
    $("#Volume").val("");
    $("#DisposalMeasures").val("");
    $("#Note").val("");
	$('#drugList').datagrid({
					 queryParams:{
            ClassName:"web.DHCANControlledDrug",
            QueryName:"FindDrugInfoList"
        },
        onBeforeLoad:function(param)
        {
	        param.opaId=opaId;
        }
		})	

	
}
function AddFData()
{
	$("#operDialog").dialog({
        title: "����ҩ�Ǽ�",
        iconCls: "icon-w-edit"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");

}
//
//���
function addDrug(){
    var drugId = $("#Drug").combobox("getValue");
    var drugDesc = $HUI.combobox("#Drug").getText();
    if(drugId==drugDesc)
    {
	    //$.messager.alert("��ʾ","���ҩ����������ѡ��ҩ��!","info");
		 // return; 
    }
    var BatchNo=$("#BatchNo").val();
    var Quantity=$("#Quantity").val();
    var usecount=$("#Volume").val();
    var DisposalMeasures=$("#DisposalMeasures").val();
    var Note=$("#Note").val();
    var  HandlerId= $("#Handler").combobox("getValue");
    var  Handler= $HUI.combobox("#Handler").getText();
    var  ReCheckId= $("#ReChecker").combobox("getValue");
    var  ReChecker= $HUI.combobox("#ReChecker").getText();
    var  RecipientId= $("#Reciever").combobox("getValue");
    var  Recipient= $HUI.combobox("#Reciever").getText();
	var UomId=$HUI.combobox("#Uom").getValue();
	var Uom=$HUI.combobox("#Uom").getText();
	var UnitId=$HUI.combobox("#Unit").getValue();
	var Unit=$HUI.combobox("#Unit").getText();
   
    if (drugDesc && drugDesc != "") {
        $HUI.datagrid("#drugList").appendRow({
	        ANCDRowId:"",
            drugDesc: drugDesc,
            BatchNo: BatchNo,
            Quantity: Quantity,
			Unit:Unit,
			UnitId:UnitId,
            usecount: usecount,
			UomId:UomId,
			Uom:Uom,
            DisposalMeasures: DisposalMeasures,
            Handler: Handler,
            ReChecker: ReChecker,
            Recipient: Recipient,
            Note: Note,
            orderDoc:orderDoc,
            orderDocId:orderDocId,
            drugId: drugId,
            HandlerId: HandlerId,
            ReCheckId: ReCheckId,
            RecipientId: RecipientId
        }); 
    }
    $('#Drug').combobox("setValue","");
	$('#Handler').combobox("setValue","");
	$('#ReChecker').combobox("setValue","");
	$('#Reciever').combobox("setValue","");
	$("#Unit").combobox("setValue","");
	$("#Uom").combobox("setValue","");
	$("#BatchNo").val("");
    $("#Quantity").val("");
    $("#Volume").val("");
    $("#DisposalMeasures").val("");
    $("#Note").val("");

}

function editDrug()
{
	var selectRow=$("#drugList").datagrid("getSelected");
    var selindex=$("#drugList").datagrid("getRowIndex",selectRow);;
    if(selectRow)
    {
    var drugId = $("#Drug").combobox("getValue");
    var drugDesc = $HUI.combobox("#Drug").getText();
    var BatchNo=$("#BatchNo").val();
    var Quantity=$("#Quantity").val();
    var usecount=$("#Volume").val();
    var DisposalMeasures=$("#DisposalMeasures").val();
    var Note=$("#Note").val();
   var  HandlerId= $("#Handler").combobox("getValue");
    var  Handler= $HUI.combobox("#Handler").getText();
    var  ReCheckId= $("#ReChecker").combobox("getValue");
    var  ReChecker= $HUI.combobox("#ReChecker").getText();
   var  RecipientId= $("#Reciever").combobox("getValue");
    var  Recipient= $HUI.combobox("#Reciever").getText();
	var UomId=$HUI.combobox("#Uom").getValue();
	var Uom=$HUI.combobox("#Uom").getText();
	var UnitId=$HUI.combobox("#Unit").getValue();
	var Unit=$HUI.combobox("#Unit").getText();
	ANCDRowId=selectRow.ANCDRowId;
    if (drugDesc && drugDesc != "") {
        $("#drugList").datagrid("updateRow",{
	        index:selindex,
	        row:{
		    ANCDRowId:ANCDRowId,
            drugDesc: drugDesc,
            BatchNo: BatchNo,
            Quantity: Quantity,
            Unit:Unit,
			UnitId:UnitId,
            usecount: usecount,
			UomId:UomId,
			Uom:Uom,
            DisposalMeasures: DisposalMeasures,
            Handler: Handler,
            ReChecker: ReChecker,
            Recipient: Recipient,
            Note: Note,
            orderDoc:orderDoc,
            orderDocId:orderDocId,
            drugId: drugId,
            HandlerId: HandlerId,
            ReCheckId: ReCheckId,
            RecipientId: RecipientId
	        }
        }); 
        $HUI.combobox("#Drug").clear();
        $HUI.combobox("#Handler").clear();
        $HUI.combobox("#ReChecker").clear();
        $HUI.combobox("#Reciever").clear();
		$("#Unit").combobox("setValue","");
		$("#Uom").combobox("setValue","");
        $("#BatchNo").val("");
    	$("#Quantity").val("");
    	$("#Volume").val("");
    	$("#DisposalMeasures").val("");
    	$("#Note").val("");
    	}
    }
    else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'warning');
        return;
    	}

}
function removeDrug()
{
	 var selectRow=$HUI.datagrid("#drugList").getSelected(),
     selectRowIndex=$HUI.datagrid("#drugList").getRowIndex(selectRow);
    if(selectRow)
    {
        $HUI.datagrid("#drugList").deleteRow(selectRowIndex);
    }else{
        $.messager.alert("��ʾ","��ѡ��Ҫɾ������","warning");
        return;
    }
    $('#Drug').combobox("setValue","");
	$('#Handler').combobox("setValue","");
	$('#ReChecker').combobox("setValue","");
	$('#Reciever').combobox("setValue","");
	$("#Unit").combobox("setValue","");
	$("#Uom").combobox("setValue","");
	$("#BatchNo").val("");
    $("#Quantity").val("");
    $("#Volume").val("");
    $("#DisposalMeasures").val("");
    $("#Note").val("");

}
//���澫��ҩ��Ϣ
function SaveDrugInfo()
{
	var datas=$("#drugList").datagrid('getData')
        drugInfoStr="";
    if(datas.total>0) 
    {
	    for(var i=0;i<datas.total;i++)
	    {
	        var ANCDRowId=datas.rows[i].ANCDRowId;
	        var drugId=datas.rows[i].drugId;
	        var BatchNo=datas.rows[i].BatchNo;
	        var Quantity=datas.rows[i].Quantity;
			var UnitId=datas.rows[i].UnitId;
	        var usecount=datas.rows[i].usecount;
			var UomId=datas.rows[i].UomId;
	        var DisposalMeasures=datas.rows[i].DisposalMeasures;
	        var Note=datas.rows[i].Note;
	        var HandlerId=datas.rows[i].HandlerId;
	        var ReCheckId=datas.rows[i].ReCheckId;
	        var RecipientId=datas.rows[i].RecipientId;
	        var OeordDocDr=logUserId; //datas.rows[i].orderDocId;
	        var drugDesc=datas.rows[i].drugDesc;
	        if(drugInfoStr!="")
	        {
		        drugInfoStr=drugInfoStr+"^"+ANCDRowId+"#"+drugId+"#"+BatchNo+"#"+Quantity+"#"+UnitId+"#"+usecount+"#"+UomId+"#"
	        +DisposalMeasures+"#"+Note+"#"+HandlerId+"#"+ReCheckId+"#"+RecipientId+"#"+OeordDocDr+"#"+drugDesc;
	        }
	        else
	        {
		        drugInfoStr=ANCDRowId+"#"+drugId+"#"+BatchNo+"#"+Quantity+"#"+UnitId+"#"+usecount+"#"+UomId+"#"
	        +DisposalMeasures+"#"+Note+"#"+HandlerId+"#"+ReCheckId+"#"+RecipientId+"#"+OeordDocDr+"#"+drugDesc;
	        }
	    }
    }
   if(drugInfoStr=="")
   {
	   $.messager.confirm("ȷ��","��ոû����������о���ҩ�Ǽ���Ϣ��",function(r){
                if(r)
                {
                    
                }else{
	                return;
                    //window.close();
                }
             })
   }
   //console.log("opaId:"+opaId,"drugInfoStr:"+drugInfoStr);
    var ret=$.m({
	ClassName:"web.DHCANControlledDrug",
	MethodName:"UpdateDrugInfoList",
	opaId:opaId,
	drugInfoStr:drugInfoStr
	 },false);
    if(ret!=0)
    {
	    $.messager.alert("��ʾ",ret,"error");
    }
    else
    {
	    $.messager.alert("��ʾ","�Ǽǳɹ�","info");
    }

}
//
	function GetFilePath()
	{
		var path=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetPath"
    },false);
    return path;
	}
   function ExportCDD()
    {
	    var name,fileName,path,operStat,printTitle;
	    var xlgendercel,xlsBook,xlsSheet,titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	    path=GetFilePath();
	    fileName=path+"DHCANOPControlledDrug.xlsx";
	    
	    //fileName=path+"DHCBPDetection.xlsx";
	    xlgendercel = new ActiveXObject("Excel.Application");
	    xlsBook = xlgendercel.Workbooks.Add(fileName);
	    xlsSheet = xlsBook.ActiveSheet;
	    //alert("?")
	    //return;
	    printLen=30
	    row=0
	    var operlistdata=$("#OperListBox").datagrid('getData');
	    var count =operlistdata.total;
	    for(var i=0;i<count;i++)
	    {
		    var record=operlistdata.rows[i];
			row=row+1;
			var opdate="",comOpRoom="",regNo="",patName="",gender="",age="",PDVAnumber="",diag="",Note="",opaId=""
		    var DrugDesc="",Specification="",Unit="",Quantity="",BatchNo="",orderdoctor="",usecount="",DisposalMeasures="",Handler="",Reviewer="",Recipient=""
		    var opdate=record.opdate;
			var comOpRoom=record.comOpRoom;
			var regNo=record.regNo; 
			var patName=record.patName; 
			var gender=record.gender;
			var age=record.age;
			var PDVAnumber=record.PDVAnumber;
			var diag=record.diag;
			var Note=record.Note;
			var opaId=record.opaId;
			var DrugDesc=record.DrugDesc;
			var Specification=record.Specification;
			var Unit=record.Unit;
			var Quantity=record.Quantity;
			var BatchNo=record.BatchNo;
			var orderdoctor=record.orderdoctor;
			var usecount=record.usecount;
			var DisposalMeasures=record.DisposalMeasures;
			var Handler=record.Handler;
			var Reviewer=record.Reviewer;
			var Recipient=record.Recipient;
			xlsSheet.cells(1,1)="����ҩ����ͳ��";
			xlsSheet.cells(2,1)="ʹ������";
			xlsSheet.cells(2,2)="������";
			xlsSheet.cells(2,3)="�����ǼǺ�";
			xlsSheet.cells(2,4)="��������";
			xlsSheet.cells(2,5)="�Ա�";
			xlsSheet.cells(2,6)="����";
			xlsSheet.cells(2,7)="���֤���";
			xlsSheet.cells(2,8)="�ٴ����";
		    xlsSheet.cells(2,9)="ҩƷ����";
			xlsSheet.cells(2,10)="���";
			xlsSheet.cells(2,11)="��λ";
			xlsSheet.cells(2,12)="����";
			xlsSheet.cells(2,13)="����";
			xlsSheet.cells(2,14)="����ҽʦ";
			xlsSheet.cells(2,15)="��ҩ��";
			xlsSheet.cells(2,16)="����ҩҺ���ô�ʩ";
			xlsSheet.cells(2,17)="ִ����";
			xlsSheet.cells(2,18)="������";
			xlsSheet.cells(2,19)="�հ�곽�����";
			xlsSheet.cells(2,20)="��ע";
			
			xlsSheet.cells(3+(row-1),1)=opdate;
			xlsSheet.cells(3+(row-1),2)=comOpRoom;
			xlsSheet.cells(3+(row-1),3)=regNo;
			xlsSheet.cells(3+(row-1),4)=patName;
			xlsSheet.cells(3+(row-1),5)=gender;	
			xlsSheet.cells(3+(row-1),6)=age;
			xlsSheet.cells(3+(row-1),7)=PDVAnumber;
			xlsSheet.cells(3+(row-1),8)=diag;
			xlsSheet.cells(3+(row-1),9)=DrugDesc;
			xlsSheet.cells(3+(row-1),10)=Specification;
			xlsSheet.cells(3+(row-1),11)=Unit;
			xlsSheet.cells(3+(row-1),12)=Quantity;	
			xlsSheet.cells(3+(row-1),13)=BatchNo;
			xlsSheet.cells(3+(row-1),14)=orderdoctor;
			xlsSheet.cells(3+(row-1),15)=usecount;
			xlsSheet.cells(3+(row-1),16)=DisposalMeasures;		
			xlsSheet.cells(3+(row-1),17)=Handler;
			xlsSheet.cells(3+(row-1),18)=Reviewer;
			xlsSheet.cells(3+(row-1),19)=Recipient;
			xlsSheet.cells(3+(row-1),20)=Note;
		}
		LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "";
		titleRows = 0,titleCols = 0,LeftHeader = " ",CenterHeader = " ",
		RightHeader = " ",LeftFooter = "",CenterFooter = "",RightFooter = " &N - &P ";
		//xlgendercel.Visible = true;
		var savefileName="d:\\";
			var d = new Date();
			savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xls"
			xlsSheet.SaveAs(savefileName);	
		alert("�뵽D�̲���!")
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;


    }

//��ȡ��������
function getLogLocType(){
    var logLocType="App";
    var locFlag=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"ifloc",
        Loc:logLocId
    },false);
    if(locFlag==1) logLocType="OP";
	if(locFlag==2) logLocType="AN";
    return logLocType;
}
//��ȡ��¼�û�����
function getLogUserType(){
    var logUserType="";
    var userType=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetUserType",
        userId:logUserId
    },false);
    var locFlag=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"ifloc",
        Loc:logLocId
    },false);
    if((locFlag==1)||(locFlag==2))
    {
        if ((locFlag==1)&&(userType=="NURSE"))  logUserType="OPNURSE";
		if ((locFlag==2)&&(userType=="NURSE"))	logUserType="ANNURSE";
		if ((locFlag==2)&&(userType=="DOCTOR"))	logUserType="ANDOCTOR";
    }
    return logUserType;
}

function RegSearch()
{
	if(window.event.keyCode==13)
	{
		var newregno=$.m({
        ClassName:"web.DHCDTHealthCommon",
        MethodName:"FormatPatientNo",
        PatientNo:$("#RegNo").val()
    },false);

		$("#RegNo").val(newregno);
		$HUI.datagrid("#OperListBox").load();
	}
}