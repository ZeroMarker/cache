var editFlag="undefined";
var SelectRowID="";
var EQRowID=getElementValue("EQRowID");
var EQUseLocDR=getElementValue("EQUseLocDR");
var CARowID=getElementValue("CARowID");
var CAEquipDR=getElementValue("CAEquipDR");
var CAAllotType=getElementValue("CAAllotType");
var CATypes=getElementValue("CATypes");
var CAHold2=getElementValue("CAHold2");
var ReadOnly=getElementValue("ReadOnly");
var CAHold1=parseFloat(getElementValue("CAHold1"));
var Columns=getCurColumnsInfo('EM.G.Depre.CostAllot','','','')
var ObjSources=new Array();
var HasDepre=tkMakeServerCall("web.DHCEQ.Plat.BUSMonthDepre","EQHasDepre",getElementValue("EQRowID"));

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage(); //��ȡ����ҵ����Ϣ
    initLookUp();
	defindTitleStyle(); 
    initButton();
    initButtonWidth();
    fillData();	//��ʼ���豸��Ϣ
    initEditDepreInfo();
    setRequiredElements("EQDepreMethodDR_DMDesc",true);
	$HUI.datagrid("#tDHCEQCostAllot",{   
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.Plat.BUSMonthDepre",
	        	QueryName:"CostAllot",
				CARowID:CARowID,
				Amount:CAHold1,
				LocID:EQUseLocDR,
				DepreFee:getElementValue("EQPreMonthDepre"),
				vCATypes:CATypes,
				vCAHold2:CAHold2,
				vCAAllotType:CAAllotType
			},
			border:false,
			rownumbers:true,
			singleSelect:true,
			fitColumns:true,
			toolbar:[{
				iconCls:'icon-add',
				text:'����',
				id:'add',
				handler:function(){insertRow();}
			},
			{
                iconCls: 'icon-cancel',
				text:'ɾ��',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
		    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
				if (editFlag!=rowIndex) 
				{
					if (endEditing())
					{
						$('#tDHCEQCostAllot').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
						editFlag = rowIndex;
						modifyBeforeRow = $.extend({},$('#tDHCEQCostAllot').datagrid('getRows')[editFlag]);
						bindGridEvent();  //�༭�м�����Ӧ
					} else {
						$('#tDHCEQCostAllot').datagrid('selectRow', editFlag);
					}
				}
				else
				{
					endEditing();
				}
		    
	        },
			onSelect:function(index,row){
				if (SelectRowID!=index)
				{
					SelectRowID=index
				}
				else
				{
					SelectRowID=""
				}
			},
			onLoadSuccess:function(){
				var rows = $('#tDHCEQCostAllot').datagrid('getRows');
			    for (var i = 0; i < rows.length; i++)
			    {
					ObjSources[i]=new SourceInfo(rows[i].CALAllotLocDR);
			    }
			}
	});
	var ReadOnly=getElementValue("ReadOnly")
	if ((ReadOnly==1)||(ReadOnly=="Y"))
	{
		$("#add").linkbutton("disable");
		$("#delete").linkbutton("disable");
		$("#BSave").linkbutton("disable");
	}
	$('input#EQDepreTotalFee').on('keyup',function(){
        ChangeDepreTotalFee_Changed();
    })
    $('input#EQNetFee').on('keyup',function(){
        ChangeNetFee_Changed();
    })
    $('input#EQDepreTotal').on('keyup',function(){
        ChangeDepreTotal_Changed();
    })
    $('input#EQRemainDepreMonth').on('keyup',function(){
        ChangeRemainDepreTotal_Changed();
    })
    $('input#EQLimitYearsNum').on('keyup',function(){
        ChangeLimitYearsNum_Changed();
    })
}

function fillData()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BUSMonthDepre","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	showFundsTip(jsonData.Data);
	$("#EQDepreStatus").switchbox('setValue',JSON.parse(jsonData.Data.EQDepreStatus));
}

function endEditing()
{
	if (editFlag == undefined){return true}
	if ($('#tDHCEQCostAllot').datagrid('validateRow', editFlag)){
		$('#tDHCEQCostAllot').datagrid('endEdit', editFlag);
		editFlag = undefined;
		return true;
	} else {
		return false;
	}
}

function initCAAllotType()
{
	var data=[{
				id: '0',
				text: '�̶�����(%)'
			}]
	if (CATypes==2)	data=[{id: '0',text: '�̶�����(%)'},{	id: '6',text: '�̶�ֵ'}] 
	var CAAllotType = $HUI.combobox('#CAAllotType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:data
	});
	
}
function bindGridEvent()
{
	if (editFlag == undefined){return true}
    try
    {
        var objGrid = $("#tDHCEQCostAllot");
        var invRateEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
        var invValueEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
        var EQPreMonthDepre=parseFloat(getElementValue("EQPreMonthDepre"));
		var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
        
        // ����  �� �뿪�¼�
        $(invRateEdt.target).bind("blur",function(){
            var CALAllotPercentNum=parseFloat($(invRateEdt.target).val());
	        var CALWorkLoadNum=CAHold1*(CALAllotPercentNum/100)
			CALWorkLoadNum=CALWorkLoadNum.toFixed(2)
	        
	        //���·�ֵ̯
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALWorkLoadNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
			$(CALWorkLoadNumEditor.target).val(CALWorkLoadNum);
			
			//���·�̯���۾�
			var CALDepreFee=EQPreMonthDepre*(CALAllotPercentNum/100);
			rowData.CALDepreFee=CALDepreFee.toFixed(2);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
        $(invValueEdt.target).bind("blur",function(){
            var CALWorkLoadNum=parseFloat($(invValueEdt.target).val());
	        //var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	        var CALAllotPercentNum=CALWorkLoadNum*100/CAHold1;
			CALAllotPercentNum=CALAllotPercentNum.toFixed(2)
			
			//���·�̯����
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALAllotPercentNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
			$(CALAllotPercentNumEditor.target).val(CALAllotPercentNum);
			
			//���·�̯���۾�
			var CALDepreFee=EQPreMonthDepre*(CALAllotPercentNum/100);
			rowData.CALDepreFee=CALDepreFee.toFixed(2);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
// ��������
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
    var rows = $("#tDHCEQCostAllot").datagrid('getRows');
    var lastIndex=rows.length-1
    if (lastIndex==-1) lastIndex=0
    var newIndex=rows.length
	$("#tDHCEQCostAllot").datagrid('insertRow', {index:newIndex,row:{}});
	editFlag=0;
}

function DeleteData()
{
	var graidLength=$('#tDHCEQCostAllot').datagrid('getRows').length;
	if(graidLength<2)
	{
		messageShow("alert",'info',"��ʾ","��ǰ�в���ɾ��!");
		return;
	}
	if (editFlag != undefined)
	{
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
		$('#tDHCEQCostAllot').datagrid('deleteRow',editFlag);
	} 
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}
}

function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	
	var dataList=""
	var rows = $('#tDHCEQCostAllot').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.CALAllotLocDR=="")
		{
			alertShow("��"+(i+1)+"�п���ID����Ϊ��!")
			return "-1"
		}
		if ((oneRow.CALAllotPercentNum=="")&&(CAAllotType!="6"))
		{
			alertShow("��"+(i+1)+"�з�̯�ٷֱȲ���Ϊ��!")
			return "-1"
		}
		if (oneRow.CALWorkLoadNum=="")
		{
			alertShow("��"+(i+1)+"�з�̯��Ȳ���Ϊ��!")
			return "-1"
		}
		
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (dataList=="")
	{
		alertShow("��̯��ϸ����Ϊ��!");
		return;
	}
	
	if((CAAllotType=="")||(CATypes=="")||(CAHold2==""))
	{
		alertShow("�豸��̯�����п�ֵ!");
		return;
	}
	
	if((CAAllotType=="")||(CATypes=="")||(CAHold2==""))
	{
		alertShow("�豸��̯�����п�ֵ!");
		return;
	}
	
	if((getElementValue("EQDepreMethodDR")==""))
	{
		alertShow("�۾ɷ�������Ϊ��!");
		return;
	}
	
	//�����豸��Ϣ
	var EquipInfo={};
	EquipInfo.EQRowID=EQRowID;
	EquipInfo.EQDepreMethodDR=getElementValue("EQDepreMethodDR");
	EquipInfo.EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	EquipInfo.EQStartDepreDate=getElementValue("EQStartDepreDate");
	EquipInfo.EQDepreStatus=$("#EQDepreStatus").switchbox('getValue');
	if (HasDepre!=1){
		var EQOriginalFee=Number(getElementValue("EQOriginalFee"));
		var EQDepreTotalFee=Number(getElementValue("EQDepreTotalFee"));
		var EQNetFee=Number(getElementValue("EQNetFee"));
		var EQLimitYearsNum=Number(getElementValue("EQLimitYearsNum"));
		var EQDepreTotal=getElementValue("EQDepreTotal");
		var EQRemainDepreMonth=getElementValue("EQRemainDepreMonth");
		if (parseFloat(EQDepreTotalFee.toFixed(2))<0){
			alertShow("�ۼ��۾ɲ���С��0!");
			return;
		}
		if (parseFloat(EQNetFee.toFixed(2))<0){
			alertShow("��ֵ����С��0!");
			return;
		}
		if (parseInt(EQDepreTotal)<0){
			alertShow("������������С��0!");
			return;
		}
		if (parseInt(EQRemainDepreMonth)<0){
			alertShow("ʣ����������С��0!");
			return;
		}
		if (((NumFormat(EQDepreTotalFee.toFixed(2))*100+NumFormat(EQNetFee.toFixed(2))*100)/100).toFixed(2)!=NumFormat(EQOriginalFee.toFixed(2))){
			alertShow("�ۼ��۾��뾻ֵ֮�Ͳ�����ԭֵ��������!");
			return;
		}
		if (Number(EQLimitYearsNum*12)!=(Number(EQDepreTotal)+Number(EQRemainDepreMonth))){
			alertShow("����������ʣ������֮�Ͳ������۾�����*12��������!");
			return;
		}
		if (parseInt(+EQDepreTotal)!=parseFloat(+EQDepreTotal)){
			alertShow("����������Ϊ����!");
			return;
		}else{
			var EQDepreTotal=parseInt(+EQDepreTotal);
		}
		if (parseInt(EQRemainDepreMonth)!=parseFloat(EQRemainDepreMonth)){
			alertShow("ʣ��������Ϊ����!");
			return;
		}else{
			var EQRemainDepreMonth=parseInt(+EQRemainDepreMonth);
		}
		//���޸��豸���������
		//�ۼ��۾ɲ���ȣ���¼�ĺ�ԭֵ
		if (Number(getElementValue("DepreTotalFee"))!=Number(EQDepreTotalFee)){
			EquipInfo.EQDepreTotalFee=EQDepreTotalFee;
			EquipInfo.EQNetFee=EQNetFee;
			EquipInfo.EQDepreTotal=EQDepreTotal;
			EquipInfo.EQRemainDepreMonth=EQRemainDepreMonth;
		}
		//�۾���������ȣ���¼������������
		if (Number(getElementValue("DepreTotal"))!=Number(EQDepreTotal)){
			EquipInfo.EQDepreTotalFee=EQDepreTotalFee;
			EquipInfo.EQNetFee=EQNetFee;
			EquipInfo.EQDepreTotal=EQDepreTotal;
			EquipInfo.EQRemainDepreMonth=EQRemainDepreMonth;
		}
	}
	EquipInfo=JSON.stringify(EquipInfo);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BUSMonthDepre","SaveEquipData",EquipInfo,"",curUserID,curLocID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
    {
		alertShow("�����豸�۾���Ϣʧ��!��ϸ:"+jsonData.Data);
		return
    }
	//�����۾�������Ϣ
	var CostAllot={};
	CostAllot.CARowID=CARowID;
	CostAllot.CAEquipDR=CAEquipDR;
	CostAllot.CAAllotType=CAAllotType;
	CostAllot.CATypes=CATypes;
	CostAllot.CAHold1=CAHold1;
	CostAllot.CAHold2=CAHold2;
	CostAllot=JSON.stringify(CostAllot);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSCostAllot","SaveData",CostAllot,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&EQRowID="+EQRowID+"&ReadOnly="+ReadOnly;
		url="dhceq.em.depreset.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID.split("_")[0],rowData.TRowID);
}

function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

function GetUseLoc(index,data)
{
	var Length=ObjSources.length
	for (var i=0;i<Length;i++)
	{
		if ((ObjSources[i].SourceID==data.TRowID)&&(editFlag!=i))
		{
			var RowNo=i+1
			alertShow("ѡ��Ŀ������"+RowNo+"���ظ�!")
			return;
		}
	}
	
	var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	rowData.CALAllotLocDR=data.TRowID;
	ObjSources[index]=new SourceInfo(rowData.CALAllotLocDR);
	var editor = $('#tDHCEQCostAllot').datagrid('getEditor',{index:editFlag,field:'CALAllotLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
}

function SourceInfo(SourceID)
{
	this.SourceID=SourceID;
}

function BClosed_Clicked() 
{
	var openerType=typeof(window.opener)
	if (openerType!="undefined")
	{
		window.close();
	}
	closeWindow('modal');
	//websys_showModal("close");
}

function showFundsTip(data)
{
	var RowID=$("#EQRowID").val();
	//�첽����
	var jsonData = $.cm({
		ClassName:"web.DHCEQ.EM.BUSFunds",
		QueryName:"GetFunds",
		FromType:"1",
		FromID:RowID,
		FundsAmount:data["EQOriginalFee"]
	},false);
	$HUI.tooltip('#EQFunds',{
		position: 'bottom',
		content: function(){
			var content='<div style="padding:5px;font-size:16px;color:#ffffff"><ul>';
			for (var i=0;i<jsonData.rows.length;i++)
			{
				var TFundsTypeDR=jsonData.rows[i].TFundsTypeDR;
				var TFundsType=jsonData.rows[i].TFundsType;
				var TFee=jsonData.rows[i].TFee;
				var TFinaceItem=jsonData.rows[i].TFinaceItem;
				var TCurDepreTotalFee=jsonData.rows[i].TCurDepreTotalFee; 
				if (TFundsTypeDR==data["EQSelfFundsFlag"]) continue;
				content=content+'<li>'+TFundsType+'��'+TFee+' '+'�ۼ��۾�:'+TCurDepreTotalFee+'</li>'; 
			}
			content=content+'</ul></div>';
			return content;
		},
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#88a8c9',
				borderColor: '#4f75aa',
				boxShadow: '1px 1px 3px #4f75aa'
			});
		 },
		onPosition: function(){
			$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
			$(this).tooltip('arrow').css('bottom', 20);
		}
	});
}

//�ж��豸�Ƿ�����۾ɣ����۾��豸�۾���Ϣ�ɱ༭
function initEditDepreInfo()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	if (HasDepre==1){
		disableElement("EQDepreTotalFee",true);
		disableElement("EQNetFee",true);
		disableElement("EQDepreTotal",true);
		disableElement("EQRemainDepreMonth",true);
	}else{
		disableElement("EQDepreTotalFee",false);
		disableElement("EQNetFee",false);
		disableElement("EQDepreTotal",false);
		disableElement("EQRemainDepreMonth",false);
	}
}

function NumFormat(Num)
{
	if (Num=="") return 0;
	else{ return parseFloat(Num);}
}

//�䶯�ۼ��۾�
function ChangeDepreTotalFee_Changed()
{
	var EQOriginalFee=getElementValue("EQOriginalFee");
	var RemainFeeRate=getElementValue("RemainFeeRate");
	var EQDepreTotalFee=Number(getElementValue("EQDepreTotalFee"));
	var tmpChangedNetFeeValue=Number(EQOriginalFee)-EQDepreTotalFee;
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(EQOriginalFee*RemainFeeRate/100).toFixed(2)
        if (tmpChangedNetFeeValue<CAChangedNetRemainFee)
        {
            alertShow("��ֵ����С�ھ���ֵ:"+CAChangedNetRemainFee);
            return
        }
    }
    setElement("EQNetFee",tmpChangedNetFeeValue.toFixed(2));
}

//�䶯��ֵ
function ChangeNetFee_Changed()
{
	var EQOriginalFee=getElementValue("EQOriginalFee");
	var RemainFeeRate=getElementValue("RemainFeeRate");
	var EQNetFee=Number(getElementValue("EQNetFee"));
	var tmpChangedTotalFeeValue=Number(EQOriginalFee)-EQNetFee;
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(EQOriginalFee*RemainFeeRate/100).toFixed(2)
        if (EQNetFee<CAChangedNetRemainFee)
        {
            alertShow("��ֵ����С�ھ���ֵ:"+CAChangedNetRemainFee);
            return
        }
    }
    setElement("EQDepreTotalFee",tmpChangedTotalFeeValue.toFixed(2));
}

function ChangeDepreTotal_Changed()
{
	var EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	var EQDepreTotal=Number(getElementValue("EQDepreTotal"));
	var tmpRemainDepreTotal=EQLimitYearsNum*12-EQDepreTotal;
    setElement("EQRemainDepreMonth",tmpRemainDepreTotal);
}

function ChangeRemainDepreTotal_Changed()
{
	var EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	var EQRemainDepreMonth=Number(getElementValue("EQRemainDepreMonth"));
	var tmpDepreTotal=EQLimitYearsNum*12-EQRemainDepreMonth;
    setElement("EQDepreTotal",tmpDepreTotal);
}

function ChangeLimitYearsNum_Changed()
{
	var EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	var EQDepreTotal=Number(getElementValue("EQDepreTotal"));
	var tmpRemainDepreTotal=EQLimitYearsNum*12-EQDepreTotal;
    setElement("EQRemainDepreMonth",tmpRemainDepreTotal);
}