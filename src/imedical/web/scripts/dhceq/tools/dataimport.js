var Job=getElementValue("Job");
var BussType=getElementValue("BussType");
var DisplayFlag="";
var columns=[];
var editIndex=undefined;
var objtbl=$('#tDHCEQImportData');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage(""); //��ȡ����ҵ����Ϣ
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    initPage();		//��ͨ�ð�ť��ʼ��
    initColumns();
    initDataGrid();
}

function initPage()
{
	
}

function initColumns()
{
	if(BussType=="11")
	{
		columns=getCurColumnsInfo('EM.G.DataImport.OpenCheck','','','');
		/*
		columns=[[
			{field:'DIRowID',title:'DIRowID',width:10,align:'left',hidden:true},
			{field:'Hold1',title:'��Ӧ��',width:150,align:'left',editor:{type: 'validatebox', options: { required: true }}},
			{field:'Hold2',title:'������ϵ��',width:80,align:'left',editor:{type:'validatebox'}},
			{field:'Hold3',title:'������ϵ��ʽ',width:150,align:'left',editor:{type:'validatebox'}},
			{field:'Hold4',title:'�豸����',width:150,align:'left',editor:{type:'validatebox', options: { required: true }}},
			{field:'Hold5',title:'�豸����',width:150,align:'left',editor:{type:'validatebox', options: { required: true }}},
			{field:'Hold6',title:'�ͺ�',width:150,align:'center',editor:{type:'validatebox'}},
			{field:'Hold7',title:'ԭֵ',width:80,align:'center',editor:{type:'validatebox', options: { required: true }}},
			{field:'Hold8',title:'����',width:100,align:'center',editor:{type:'numberbox', options: { required: true,precision:0}}},
			{field:'Hold9',title:'��������',width:100,align:'right',editor:{type:'validatebox'}},
			{field:'Hold10',title:'����',width:100,align:'right',editor:{type:'validatebox'}},
			{field:'Hold11',title:'�������',width:100,align:'right',editor:{type:'validatebox'}},
			{field:'Hold12',title:'��������',width:100,align:'left',editor:{type:'datebox', options: { validType:'validDate[\'yyyy-mm-dd\']'}}},		
			{field:'Hold13',title:'��������',width:100,align:'left',editor:{type:'datebox', options: { validType:'validDate[\'yyyy-mm-dd\']'}}},
			{field:'Hold14',title:'������(��)',width:100,align:'left',editor:{type:'text'}},
			{field:'Hold15',title:'��ͬ��',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold16',title:'��ע',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold17',title:'��Դ',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold18',title:'�ɹ���ʽ',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold19',title:'�깺���',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold20',title:'�豸��;',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold21',title:'ʹ�ÿ���',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold22',title:'������',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold23',title:'������Դ',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold24',title:'��ŵص�',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold25',title:'������־',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold26',title:'��ҽ��־',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold27',title:'�����־',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold28',title:'ע��֤��',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold29',title:'Ʒ��',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold30',title:'��Ʊ��',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold31',title:'��Ŀ����',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold32',title:'���ս���',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold33',title:'�������',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold34',title:'�������',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold35',title:'����ļ�',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold36',title:'��������',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold56',title:'У����',width:200,align:'left'},
			{field:'TDiffFlag',title:'TDiffFlag',width:10,align:'left',hidden:true}
		]]
		*/
	}
}

function initDataGrid()
{
	$HUI.datagrid("#tDHCEQImportData",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.Tools.DataImport",
	        	QueryName:"GetImportData",
	        	BussType:BussType,
	        	CurUserID:curUserID,
				Job:Job
			},
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			//singleSelect:true,
			fit:true,
			border:false,
			nowrap:false,
			toolbar:[{
					iconCls:'icon-add',
					text:'��������',
					handler:function(){ImportData();}
				}/*,{
					iconCls:'icon-checkin',
					text:'У������',
					handler:function(){CheckData();}
				}*/,{
					iconCls:'icon-import',
					text:'��������',
					handler:function(){ExecuteData();}
				},{
					iconCls:'icon-save',
					text:'��������',
					handler:function(){SaveData();}
				},{
					iconCls:'icon-remove',
					text:'ɾ������',
					handler:function(){DeleteData();}
				}],
			columns:columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			rowStyler: function(index,row){
				var TDiffFlag=row.TDiffFlag;
				if(TDiffFlag) return 'background-color:yellow';
			},
			onClickRow:onClickRow,
			onLoadSuccess:function(){
				creatToolbar();
			}
	});
}

function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px'>ȫ������</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px;'>�쳣����</a>"
	
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BAll_Clicked);
	}
	if (jQuery("#diffflag").length>0)
	{
		jQuery("#diffflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#diffflag").on("click", BDiff_Clicked);
	}
}

function ImportData()
{
	if (websys_isIE)
	{
		BImport_IE();
	}
	else
	{
		BImport_Chrome();
	}
}

function BImport_Chrome()
{
	var val=curLocID;
	if (val!="")
	{
		var result=tkMakeServerCall("web.DHCEQCommon","CheckLocType",'0101',val);
		if (result=="-1")
		{
			messageShow("","","","��ǰ�豸�ⷿ���ǿⷿ!")
			return 0;
		}
		var result=tkMakeServerCall("web.DHCEQCommon","LocIsInEQ",'1',val);
		if (result=="1")
		{
			messageShow("","","","��ǰ�豸�ⷿ���ڵ�¼��ȫ�����Χ��!")
			return 0;
		}
	}
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		messageShow("","","","û�����ݵ��룡")
		return 0;
	}
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
		var Provider=trim(RowInfo[Row-1][Col++]);
		var ProviderHandler=trim(RowInfo[Row-1][Col++]);
		var ProviderTel=trim(RowInfo[Row-1][Col++]);
		var EquipType=trim(RowInfo[Row-1][Col++]);
		var Name=trim(RowInfo[Row-1][Col++]);
		if (Name=="") continue;
		var Model=trim(RowInfo[Row-1][Col++]);
		var OriginalFee=trim(RowInfo[Row-1][Col++]);
		var Quantity=trim(RowInfo[Row-1][Col++]);
		var ManuFactory=trim(RowInfo[Row-1][Col++]);
		var Country=trim(RowInfo[Row-1][Col++]); 
		var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
		var LeaveFactoryDate=trim(RowInfo[Row-1][Col++]);
		LeaveFactoryDate=changeDateFormat(LeaveFactoryDate);
		var CheckDate=trim(RowInfo[Row-1][Col++]);
		CheckDate=changeDateFormat(CheckDate);
		var GuaranteePeriodNum=trim(RowInfo[Row-1][Col++]);	//������
		var ContractNo=trim(RowInfo[Row-1][Col++]);	//��ͬ��
		var Remark=trim(RowInfo[Row-1][Col++]);
		var Origin=trim(RowInfo[Row-1][Col++]);
		var BuyType=trim(RowInfo[Row-1][Col++]);
		var PurchaseType=trim(RowInfo[Row-1][Col++]);
		var PurposeType=trim(RowInfo[Row-1][Col++]);
		var UseLoc=trim(RowInfo[Row-1][Col++]);
		var FileNo=trim(RowInfo[Row-1][Col++]);
		var Expenditures=trim(RowInfo[Row-1][Col++]);
		var Location=trim(RowInfo[Row-1][Col++]);
		var MeasureFlag=trim(RowInfo[Row-1][Col++]);
		var Hold7=trim(RowInfo[Row-1][Col++]);  //��ҽ��־
		var Hold6=trim(RowInfo[Row-1][Col++]);  //�����־
		var Hold2=trim(RowInfo[Row-1][Col++])  //ע��֤��
		var Brand=trim(RowInfo[Row-1][Col++])  //Ʒ��
		var Hold1=trim(RowInfo[Row-1][Col++])  //��Ʊ��
		var Hold11=trim(RowInfo[Row-1][Col++])  //��Ŀ����
		var CheckResult=trim(RowInfo[Row-1][Col++])  //���ս���
		var ConfigState=trim(RowInfo[Row-1][Col++])  //�������
		var RunningState=trim(RowInfo[Row-1][Col++])  //�������
		var FileState=trim(RowInfo[Row-1][Col++])  //����ļ����
		var PackageState=trim(RowInfo[Row-1][Col++])  //��������
		
		var combindata=""; 
		combindata=combindata+"^"+Provider;		//2
		combindata=combindata+"^"+ProviderHandler;
		combindata=combindata+"^"+ProviderTel;
		combindata=combindata+"^"+EquipType;	//5
		combindata=combindata+"^"+Name;		//6
		combindata=combindata+"^"+Model;	//7
		combindata=combindata+"^"+OriginalFee;
		combindata=combindata+"^"+Quantity;
		combindata=combindata+"^"+ManuFactory;	//10
		combindata=combindata+"^"+Country;
		combindata=combindata+"^"+LeaveFactoryNo;
		combindata=combindata+"^"+LeaveFactoryDate;
		combindata=combindata+"^"+CheckDate;
		combindata=combindata+"^"+GuaranteePeriodNum;
		combindata=combindata+"^"+ContractNo;
		combindata=combindata+"^"+Remark;
		combindata=combindata+"^"+Origin;	//18
		combindata=combindata+"^"+BuyType;	//19
		combindata=combindata+"^"+PurchaseType;	//20
		combindata=combindata+"^"+PurposeType;	//21
		combindata=combindata+"^"+UseLoc;		//22
		combindata=combindata+"^"+FileNo;
		combindata=combindata+"^"+Expenditures;
		combindata=combindata+"^"+Location;		//25
		combindata=combindata+"^"+MeasureFlag;	//26
		combindata=combindata+"^"+Hold7;
		combindata=combindata+"^"+Hold6;
		combindata=combindata+"^"+Hold2;
		combindata=combindata+"^"+Brand;		//30
		combindata=combindata+"^"+Hold1;
		combindata=combindata+"^"+Hold11;
		combindata=combindata+"^"+CheckResult;	//33
		combindata=combindata+"^"+ConfigState;	//34
		combindata=combindata+"^"+RunningState;	//35
		combindata=combindata+"^"+FileState;	//36
		combindata=combindata+"^"+PackageState;	//37
		
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveData",combindata,BussType,curUserID,Job,Row);
		var JsonData=JSON.parse(result);
		if(JsonData.SQLCODE!=0){
			if (Error=="") Error=JsonData.Data;
			else Error=Error+";"+JsonData.Data;
		}
	}
	if (Error!="") alert(Error)
	else{
		alert("����װ�سɹ�!")
		BFind_Clicked();
	}
}

function BImport_IE()
{
	var val=curLocID;
	if (val!="")
	{
		var result=tkMakeServerCall("web.DHCEQCommon","CheckLocType",'0101',val);
		if (result=="-1")
		{
			messageShow("","","","��ǰ�豸�ⷿ���ǿⷿ!")
			return 0;
		}
		var result=tkMakeServerCall("web.DHCEQCommon","LocIsInEQ",'1',val);
		if (result=="1")
		{
			messageShow("","","","��ǰ�豸�ⷿ���ڵ�¼��ȫ�����Χ��!")
			return 0;
		}
	}
	
	var Error=""
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("���յ�");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var Provider=trim(xlsheet.cells(Row,Col++).text);
		var ProviderHandler=trim(xlsheet.cells(Row,Col++).text);
		var ProviderTel=trim(xlsheet.cells(Row,Col++).text);
		var EquipType=trim(xlsheet.cells(Row,Col++).text);
		var Name=trim(xlsheet.cells(Row,Col++).text);
		if (Name=="") continue;
		var Model=trim(xlsheet.cells(Row,Col++).text);
		var OriginalFee=trim(xlsheet.cells(Row,Col++).text);
		var Quantity=trim(xlsheet.cells(Row,Col++).text);
		var ManuFactory=trim(xlsheet.cells(Row,Col++).text);
		var Country=trim(xlsheet.cells(Row,Col++).text); 
		var CountryDR="";   
		var LeaveFactoryNo=trim(xlsheet.cells(Row,Col++).text);
		var LeaveFactoryDate=trim(xlsheet.cells(Row,Col++).text);
		LeaveFactoryDate=changeDateFormat(LeaveFactoryDate);
		var CheckDate=trim(xlsheet.cells(Row,Col++).text);
		CheckDate=changeDateFormat(CheckDate);
		var GuaranteePeriodNum=trim(xlsheet.cells(Row,Col++).text);	//������
		var ContractNo=trim(xlsheet.cells(Row,Col++).text);	//��ͬ��
		var Remark=trim(xlsheet.cells(Row,Col++).text);
		var Origin=trim(xlsheet.cells(Row,Col++).text);
		var OriginDR="";
		var BuyType=trim(xlsheet.cells(Row,Col++).text);
		var BuyTypeDR="";
		var PurchaseType=trim(xlsheet.cells(Row,Col++).text);
		var PurchaseTypeDR="";
		var PurposeType=trim(xlsheet.cells(Row,Col++).text);
		var PurposeTypeDR="";    
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		var UseLocDR="";
		var FileNo=trim(xlsheet.cells(Row,Col++).text);
		var Expenditures=trim(xlsheet.cells(Row,Col++).text);
		var ExpendituresDR="";
		var Location=trim(xlsheet.cells(Row,Col++).text);
		var MeasureFlag=trim(xlsheet.cells(Row,Col++).text);
		var Hold7=trim(xlsheet.cells(Row,Col++).text);  //��ҽ��־
		var Hold6=trim(xlsheet.cells(Row,Col++).text);  //�����־
		var Hold2=trim(xlsheet.cells(Row,Col++).text)  //ע��֤��
		var Brand=trim(xlsheet.cells(Row,Col++).text)  //Ʒ��
		var Hold1=trim(xlsheet.cells(Row,Col++).text)  //��Ʊ��
		var Hold11=trim(xlsheet.cells(Row,Col++).text)  //��Ŀ����
		var CheckResult=trim(xlsheet.cells(Row,Col++).text)  //���ս���
		var ConfigState=trim(xlsheet.cells(Row,Col++).text)  //�������
		var RunningState=trim(xlsheet.cells(Row,Col++).text)  //�������
		var FileState=trim(xlsheet.cells(Row,Col++).text)  //����ļ����
		var PackageState=trim(xlsheet.cells(Row,Col++).text)  //��������
		
		var combindata=""; 
		combindata=combindata+"^"+Provider;		//2
		combindata=combindata+"^"+ProviderHandler;
		combindata=combindata+"^"+ProviderTel;
		combindata=combindata+"^"+EquipType;	//5
		combindata=combindata+"^"+Name;		//6
		combindata=combindata+"^"+Model;	//7
		combindata=combindata+"^"+OriginalFee;
		combindata=combindata+"^"+Quantity;
		combindata=combindata+"^"+ManuFactory;	//10
		combindata=combindata+"^"+Country;
		combindata=combindata+"^"+LeaveFactoryNo;
		combindata=combindata+"^"+LeaveFactoryDate;
		combindata=combindata+"^"+CheckDate;
		combindata=combindata+"^"+GuaranteePeriodNum;
		combindata=combindata+"^"+ContractNo;
		combindata=combindata+"^"+Remark;
		combindata=combindata+"^"+Origin;	//18
		combindata=combindata+"^"+BuyType;	//19
		combindata=combindata+"^"+PurchaseType;	//20
		combindata=combindata+"^"+PurposeType;	//21
		combindata=combindata+"^"+UseLoc;		//22
		combindata=combindata+"^"+FileNo;
		combindata=combindata+"^"+Expenditures;
		combindata=combindata+"^"+Location;		//25
		combindata=combindata+"^"+MeasureFlag;	//26
		combindata=combindata+"^"+Hold7;
		combindata=combindata+"^"+Hold6;
		combindata=combindata+"^"+Hold2;
		combindata=combindata+"^"+Brand;		//30
		combindata=combindata+"^"+Hold1;
		combindata=combindata+"^"+Hold11;
		combindata=combindata+"^"+CheckResult;	//33
		combindata=combindata+"^"+ConfigState;	//34
		combindata=combindata+"^"+RunningState;	//35
		combindata=combindata+"^"+FileState;	//36
		combindata=combindata+"^"+PackageState;	//37
		
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveData",combindata,BussType,curUserID,Job,Row);
		var JsonData=JSON.parse(result);
		if(JsonData.SQLCODE!=0){
			if (Error=="") Error=JsonData.Data;
			else Error=Error+";"+JsonData.Data;
		}
	}
	if (Error!="") alert(Error)
	else{
		messageShow("","","","����װ�سɹ�!")
		BFind_Clicked();
	}
}

function CheckData()
{
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","CheckData",BussType,curUserID,Job);
	
	if (result>0)
	{
		messageShow("","","",result+"������У�������鿴������!")
	}
	else
	{
		messageShow("","","","У��ɹ�����ִ�е������ݲ���!")
	}
	$("#tDHCEQImportData").datagrid('reload');
}

function ExecuteData()
{
	//$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	//ִ��ǰ�ȱ������ݣ�Ȼ��У������
	var valList=GetTableInfo(); 	//��ϸ��Ϣ
  	if (valList=="-1")  return; 	//��ϸ��Ϣ����
  	var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveDataList",valList);
  	var JsonData=JSON.parse(result);
	if(JsonData.SQLCODE!=0){
		//����ɹ���У������
		editIndex=undefined;
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","CheckData",BussType,curUserID,Job);
		if (result>0){
			messageShow("","","",result+"������У�������鿴У�������������ݱ�����������!")
			$("#tDHCEQImportData").datagrid('reload');
			return;
		}else{
			//У��ɹ���ִ�е���
			var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","ExecuteData",BussType,curUserID,Job,curSSHospitalID);
			var JsonData=JSON.parse(result);
			if(JsonData.SQLCODE!=0){
				messageShow("","","","ִ��ʧ�ܣ�������Ϣ��"+JsonData.Data)
			}else{
				if(JsonData.Data>0){
					messageShow("","","",JsonData.Data+"������ִ�д�����鿴У����!")
				}else{
					messageShow("","","","ִ�гɹ����뷵�ؽ���鿴�ѵ������յ�!")
					websys_showModal("options").mth();	//ˢ�¸�����
				}
			}
			BFind_Clicked();
		}
	}else{
		messageShow('alert','error','��ʾ',"�޸����ݱ������"+JsonData.Data);
		BFind_Clicked();
	}
}

function BAll_Clicked()
{
	DisplayFlag="";
	$("#allflag").css("color", "#FF0000");
	$("#diffflag").css("color", "#FFFFFF");
	BFind_Clicked();
}

function BDiff_Clicked()
{
	DisplayFlag="1";
	$("#allflag").css("color", "#FFFFFF");
	$("#diffflag").css("color", "#FF0000");
	BFind_Clicked();
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQImportData",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.Tools.DataImport",
	        	QueryName:"GetImportData",
				BussType:BussType,
	        	CurUserID:curUserID,
				Job:Job,
				DiffFlag:DisplayFlag
			},
	});
}

function onClickRow(index)
{
	if (editIndex!=index)
	{
		if (endEditing())
		{
			objtbl.datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},objtbl.datagrid('getRows')[editIndex]);
		} else {
			objtbl.datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function endEditing()
{
	if (editIndex == undefined){return true}
	if (objtbl.datagrid('validateRow', editIndex))
	{
		objtbl.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function SaveData()
{
	var valList=GetTableInfo(); 	//��ϸ��Ϣ
  	if (valList=="-1")  return; 	//��ϸ��Ϣ����
  	var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveDataList",valList);
  	var JsonData=JSON.parse(result);
	if(JsonData.SQLCODE!=0){
		messageShow('alert','success','��ʾ',"����ɹ�!");
		BFind_Clicked();
		editIndex=undefined;
	}
	else
	{
		messageShow('alert','error','��ʾ',JsonData.Data);
	}
}

//��ȡ�б���ϸ
function GetTableInfo()
{
	var valList="";
	if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = ""
	for (var i = 0; i < rows.length; i++) 
	{
		RowNo=i+1;
		
		var RowData=JSON.stringify(rows[i]);
		if (valList=="")
		{
			valList=RowData;
		}
		else
		{
			valList=valList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (valList=="")
	{
		messageShow('alert','error','��ʾ',"�б���ϸ����Ϊ��!");
		return -1;
	}
	return valList;
}

function GetMasterItem(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold5'});
	$(editor.target).combogrid("setValue",data.TName);
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold4'});
	$(editor.target).combogrid("setValue",data.TEquipType);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetEquipType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold4'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetModel(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold6'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function getVendor(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold1'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetManuFacturer(index,data)
{
	//var rowData = $('#tDHCEQImportData').datagrid('getSelected');
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold9'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function getUseLoc(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold21'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetBrand(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold29'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function getExpenditures(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold23'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetLocation(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold24'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetPurchaseType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold19'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetPurposeType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold20'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetCountry(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold10'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetBuyType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold18'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetOrigin(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold17'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

//excel���ڸ�ʽת�� numbΪ���֣�formatΪƴ�ӷ���-��
function changeDateFormat(cellval, format)
{
	if ((cellval=="")||(cellval==null)||(cellval==undefined)) return ""
	if ((format==undefined)||(format=="")||(format==null)) format="-";
	if (websys_isIE)
	{
		//IE
		if (typeof cellval=="string")
		{
			if (cellval.indexOf("-")>-1) return cellval;
			if (cellval.indexOf("/")>-1) return cellval.replace(/\//g,"-");
		}
		else if (typeof cellval=="number")
		{
			var time = new Date((cellval - 2) * 24 * 3600000 + 1)
		    time.setYear(time.getFullYear() - 70)
		    var year = time.getFullYear() + ''
		    var month = time.getMonth() + 1 + ''
		    var date = time.getDate() + ''
		    return year + format + month + format + date;
		}
		else if (typeof cellval=="date")
		{
			var time=new Date(cellval);
			var year = time.getFullYear() + '';
		    var month = time.getMonth() + 1 + '';
		    var date = time.getDate() + '';
		    return year + format + month + format + date;
		}
		else
		{
			return cellval;	
		}
	}
	else
	{
		//Chrome
		if (cellval.indexOf("-")>-1) return cellval;
		if (cellval.indexOf("/")>-1) return cellval.replace(/\//g,"-");
		var time = new Date((cellval - 2) * 24 * 3600000 + 1)
	    time.setYear(time.getFullYear() - 70)
	    var year = time.getFullYear() + ''
	    var month = time.getMonth() + 1 + ''
	    var date = time.getDate() + ''
	    return year + format + month + format + date
	}
}


function DeleteData()
{
	var RowsData=$('#tDHCEQImportData').datagrid('getChecked');
	var ValList=""
	
	if (RowsData.length==0){
		messageShow('alert','error','��ʾ',"δ��ѡ����!");
		return;
	}
	
	messageShow("confirm","info","��ʾ","�Ƿ�ȷ��ɾ���ѹ�ѡ����?","",function(){
		for (var i=0;i<RowsData.length;i++)
		{
			if (ValList=="")
			{
				ValList=RowsData[i].DIRowID;	
			}
			else
			{
				ValList=ValList+","+RowsData[i].DIRowID
			}
		}
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","DeleteData",ValList);
		if (result>0)
		{
			messageShow("","","",result+"������ɾ������!")
		}
		else
		{
			messageShow("","","","ɾ���ɹ�!")
		}
		$("#tDHCEQImportData").datagrid('reload');
	
	},function(){
		return;
	});
}

function getParam()
{
	
}