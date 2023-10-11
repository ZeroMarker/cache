var editFlag="undefined";
var PRRowID=getElementValue("PRRowID");
var Columns=getCurColumnsInfo('EM.G.PayRequest.PayRecord','','','')
var oneFillData={}

$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage("PayRequest");
	defindTitleStyle();
	initButtonWidth();
	initLookUp(); //��ʼ���Ŵ�
	initPRPayFromType();
	setElement("PRPayFromType","1");
	initPRSourceType();
	initPRPayMode();
    initButton(); //��ť��ʼ��
	initPanelHeaderStyle();   //add by mwz 20230427 mwz0070
	initApproveButtonNew();
	initButtonColor();
	jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-submit'});
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
    fillData(); //�������
    setEnabled(); //��ť����
	setRequiredElements("PRMakeDate^PRPayFromType^PRSourceType^PRProviderDR_VDesc^PRAccountDate")
	payRecordReload();
	changeColumnOption()
};
function BFind_Clicked()
{
	payRecordReload()
}
function BCancelSubmit_Clicked()
{
	UpdateData(0)
}
function BAudit_Clicked()
{
	UpdateData(2)
}
function BSubmit_Clicked()
{
	UpdateData(1)
}
function UpdateData(vStatus)
{
	if (PRRowID=="")
	{
		alertShow("�޸������뵥�ɲ���!");
		return;
	}
	var rows = $('#DHCEQPayRecord').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		var PRPayFee=parseFloat(oneRow.PRPayFee)
		var TNotPayAmount=parseFloat(oneRow.TNotPayAmount)
		if ((PRPayFee>TNotPayAmount)||(PRPayFee<0))
		{
			messageShow("","","","��"+(i+1)+"�и���������!")
			return
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","UpdateData",PRRowID,vStatus);
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		<!--Modify by zx 2020-03-31 �����첽,�ص�������ʽ���� BUG ZX0082-->
		/*messageShow("","","","�����ɹ�!");
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&PRRowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		url="dhceq.em.payrequest.csp?"+val
	    window.location.href= url;*/
	    messageShow('','','',"�����ɹ�!",'',function(){reloadPage(jsonData.Data);});
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (PRRowID=="")
	{
		alertShow("�޸������뵥��ɾ��!");
		return;
	}
	var truthBeTold = window.confirm(t[-9203]);
	if (!truthBeTold) return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","SaveData",PRRowID,"","1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		<!--Modify by zx 2020-03-31 �����첽,�ص�������ʽ���� BUG ZX0082-->
		/*messageShow("","","","�����ɹ�!");
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var val="&PRRowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType;
		url="dhceq.em.payrequest.csp?"+val
	    window.location.href= url;*/
	    messageShow('','','',"�����ɹ�!",'',function(){reloadPage("");});
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData.Data);
		return
    }
}
function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#DHCEQPayRecord").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
		totlefeeChange()
	}
	//��������
	if (checkMustItemNull("")) return
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var noListFlag="Y"
	var rows = $('#DHCEQPayRecord').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.Opt=="Y")
		{
			var PRPayPercent=parseFloat(oneRow.PRPayPercent)
			var PRPayFee=parseFloat(oneRow.PRPayFee)
			var TNotPayAmount=parseFloat(oneRow.TNotPayAmount)
			if (oneRow.PRItem=="")
			{
				messageShow("","","","��"+(i+1)+"���ո�����ĿΪ��!");
				return
			}
			else if (oneRow.PRQuantity=="")
			{
				messageShow("","","","��"+(i+1)+"������Ϊ��!");
				return
			}
			else if (oneRow.PRPrice=="")
			{
				messageShow("","","","��"+(i+1)+"��ԭֵΪ��!");
				return
			}
			else if (oneRow.PRPayFee=="")
			{
				messageShow("","","","��"+(i+1)+"���ո�����Ϊ��!");
				return
			}
			else if ((oneRow.PRPayPercent!="")&&((PRPayPercent>100)||(PRPayPercent<0)))
			{
				messageShow("","","","��"+(i+1)+"�и����������!")
				return
			}
			else if ((PRPayFee>TNotPayAmount)||(PRPayFee<0))
			{
				messageShow("","","","��"+(i+1)+"�и���������!")
				return
			}
			if (oneRow.PRSourceType!=getElementValue("PRSourceType"))
			{
				messageShow("","","","��"+(i+1)+"����ϸҵ���������ܵ�ҵ�����Ͳ�һ��!");
				return
			}
			noListFlag="N"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData
		}
	}
	
	if (noListFlag=="Y")
	{
		messageShow("","","","�������뵥�޸�����ϸ���ܱ���!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		<!--Modify by zx 2020-03-31 �����첽,�ص�������ʽ���� BUG ZX0082-->
		/*messageShow("","","","�����ɹ�!");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&PRRowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		url="dhceq.em.payrequest.csp?"+val
	    window.location.href= url;*/
	    messageShow('','','',"�����ɹ�!",'',function(){reloadPage(jsonData.Data);});
	}
	else
    {
	    messageShow("","","","������Ϣ:"+jsonData.Data);
		return
    }
}
function payRecordReload()
{
	var PRSourceType=getElementValue("PRSourceType")
	var PRProviderDR=getElementValue("PRProviderDR")
	var PRStatus=getElementValue("PRStatus")
	var Type=getElementValue("Type")
	var PRLocDR=getElementValue("PRLocDR")
	$HUI.datagrid("#DHCEQPayRecord",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSPayRequest",
	        	QueryName:"GetPayRecord",
				vPayRequestDR:PRRowID,
				vSourceType:PRSourceType,
				vProviderDR:PRProviderDR,
				vLocDR:PRLocDR
		},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:false,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
        toolbar:[
              {iconCls: 'icon-add',text:'����',id:'add',handler: function(){insertRow();}},
              {iconCls: 'icon-cancel',text:'ɾ��',id:'delete',handler: function(){deleteRow();}}
              ],
	    onClickRow: function (rowIndex,rowData) {//����ѡ���б༭
	    	if (((PRStatus=="")||(PRStatus==0))&&(Type==0))
	    	{
		    	if (editFlag!="undefined")
		    	{
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', editFlag);
	            }
	            jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	            payPercentOnChange(rowIndex)
	            payFeeOnChange(rowIndex)
	            payHold3Change(rowIndex)	//add by csj 2020-04-07 �ʱ������ 
	    	}
        },
		onLoadSuccess:function(){toolbarenable()}
	});
}
function toolbarenable()
{
    ///modified by ZY20230307 bug:3261903
    var rows = $('#DHCEQPayRecord').datagrid('getRows');
    var totalQuantityNum = 0;
    var totalTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
        var colValue=rows[i]["PRQuantity"];
        if (colValue=="") colValue=0;
        totalQuantityNum += parseFloat(colValue);
        colValue=rows[i]["TAllAmount"];
        if (colValue=="") colValue=0;
        totalTotalFee += parseFloat(colValue);
    }
    var lable_innerText='������:'+totalQuantityNum+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalTotalFee.toFixed(2);
    $("#sumTotal").html(lable_innerText);
    
    
    disableElement("add",true);
    disableElement("delete",true);
    if ((getElementValue("PRPayFromType")==9)&&((getElementValue("PRStatus")==0)||(getElementValue("PRStatus")==""))&&(getElementValue("Type")==0))
    {
        disableElement("add",false);
        disableElement("delete",false);
    }
}
function insertRow()
{
	alertShow("����")
}
function deleteRow()
{
	alertShow("ɾ��")
}
function totlefeeChange()
{
	var AllAmount=0
	var rows = jQuery("#DHCEQPayRecord").datagrid('getRows');
	if(rows.length<=0) return "";
	for(var i=0;i<rows.length;i++)
	{
		var Opt=$('#DHCEQPayRecord').datagrid('getRows')[i]['Opt']
		var PRPayFee=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[i]['PRPayFee']);
		if (Opt=="Y")
		{
			AllAmount=AllAmount+PRPayFee
		}
	}
	setElement("PRTotalFee",AllAmount)
	setElement("PRChineseFee",ChineseNum(AllAmount))
}
function payFeeOnChange(rowIndex)
{
    //������OnChange
    var NotPayAmount=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[rowIndex]['TNotPayAmount']); 
    var ed = $('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayFee' });
    $(ed.target).numberbox({
        precision:"2",
        onChange: function (newvalue,oldvalue) 
        {
            if (newvalue!=oldvalue)
            {
                if ((newvalue!="")&&((newvalue<0)||(newvalue>NotPayAmount)))
                {
	                messageShow("","","","����ȷ���븶����");
	                jQuery(ed.target).val("")
	                return
                }
                if (newvalue!="")
                {
					jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
					jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	                jQuery(ed.target).val(newvalue)
	                var PPed=$('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayPercent' });
	                jQuery(PPed.target).val((newvalue/NotPayAmount*100).toFixed(2))
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
                }
            }
        }
    });
    totlefeeChange()
}
function payPercentOnChange(rowIndex)
{
    //�������OnChange
    var NotPayAmount=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[rowIndex]['TNotPayAmount']);
    var ed = $('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayPercent' });
    $(ed.target).numberbox({
        precision:"2",
        onChange: function (newvalue,oldvalue) 
        {
            if (newvalue!=oldvalue)
            {
                if ((newvalue!="")&&((newvalue<0)||(newvalue>100)))
                {
	                messageShow("","","","����ȷ���븶�����");
	                jQuery(ed.target).val("")
	                return
                }
                if (newvalue!="")
                {
					jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
					jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	                jQuery(ed.target).val(newvalue)
	                var PFed=$('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayFee' });
	                jQuery(PFed.target).val((NotPayAmount*newvalue/100).toFixed(2))
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
                }
            }
        }
    });
    totlefeeChange()
}

//add by csj 2020-04-07 �ʱ������
function payHold3Change(rowIndex)
{
    //�ʱ������OnChange
    var AllAmount=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[rowIndex]['TAllAmount']);
    var ed = $('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRHold3' });
    $(ed.target).numberbox({
        precision:"2",
        onChange: function (newvalue,oldvalue) 
        {
            if (newvalue!=oldvalue)
            {
                if ((newvalue!="")&&((newvalue<0)||(newvalue>100)))
                {
	                messageShow("","","","����ȷ�����ʱ������");
	                jQuery(ed.target).val("")
	                return
                }
                if (newvalue!="")
                {
					jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
					jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	                jQuery(ed.target).val(newvalue)
	                $('#DHCEQPayRecord').datagrid('getRows')[rowIndex].PRHold4=(AllAmount*newvalue/100).toFixed(2)	//PRHold4 �ʱ����
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
                }
            }
        }
    });
    totlefeeChange()
}

function checkboxOnChange(Opt,rowIndex)
{
	var row = jQuery('#DHCEQPayRecord').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (Opt==key)
			{
				if (((val=="N")||val==""))
				{
					row.Opt="Y"
					totlefeeChange()
				}
				else
				{
					row.Opt="N"
				}
			}
		})
	}
}
function changeColumnOption()
{
	var PRPayType=$("#DHCEQPayRecord").datagrid('getColumnOption','PRPayType');	
	PRPayType.editor={type: 'combobox',options:{
					data: [{"id":"0","text":"ȫ��"},{"id":"1","text":"Ԥ����"},{"id":"2","text":"�ڿ�"},{"id":"3","text":"β��"}],
                    valueField: "id",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#DHCEQPayRecord").datagrid('getEditor',{index:editFlag,field:'PRPayType'});
						jQuery(ed.target).val(option.id);
						jQuery(ed.target).combobox('setValue', option.text);
						if (option.id=="0")
						{
							var ed=jQuery("#DHCEQPayRecord").datagrid('getEditor',{index:editFlag,field:'PRPayPercent'});
							jQuery(ed.target).val(100)
							var ed=jQuery("#DHCEQPayRecord").datagrid('getEditor',{index:editFlag,field:'PRPayFee'});
							jQuery(ed.target).val(parseFloat($('#DHCEQPayRecord').datagrid('getRows')[editFlag]['TNotPayAmount']))
							totlefeeChange()
						}
						jQuery("#DHCEQPayRecord").datagrid('endEdit', editFlag);
						//jQuery("#DHCEQPayRecord").datagrid('beginEdit', editFlag);	// MZY0123	2665275		2022-05-12
					}
		}};
}
function fillData()
{
	if (PRRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetOnePayRequest",PRRowID,ApproveRoleDR,Action,Step)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
}
function setEnabled()
{
	var PRStatus=getElementValue("PRStatus")
	var Type=getElementValue("Type")
	if (PRStatus=="")
	{
		disableElement("BSubmit",true)
		disableElement("BCancelSubmit",true)
		disableElement("BDelete",true)
		disableElement("BAudit",true)
		disableElement("BPicture",true); // add By QW20210422 BUG:QW0099 ����ͼƬ�ϴ�
	}
	if (PRStatus=="0")
	{
		disableElement("BCancelSubmit",true)
		disableElement("BAudit",true)
	}
	if (PRStatus=="1")
	{
		disableElement("BFind",true)
		disableElement("BSave",true)
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
	}
	if (PRStatus=="2")
	{
		disableElement("BFind",true)
		disableElement("BSave",true)
		disableElement("BSubmit",true)
		disableElement("BCancelSubmit",true)
		disableElement("BDelete",true)
		disableElement("BAudit",true)
	}
	if (Type=="0")
	{
		hiddenObj("BCancelSubmit",true)
		hiddenObj("BAudit",true)
	}
	if (Type=="1")
	{
		hiddenObj("BFind",true)
		hiddenObj("BSave",true)
		hiddenObj("BSubmit",true)
		hiddenObj("BDelete",true)
	}
}
function initPRPayMode()
{
	var PRPayMode = $HUI.combobox('#PRPayMode',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '1',text: '�ֽ�'},{id: '2',text: '֧Ʊ'},{id: '3',text: '���'}],
		onSelect : function(){}
	});
}

function CustomData(OneCustomStr)
{
	var Str=OneCustomStr.split("^")
	this.id=Str[0]
	this.text=Str[1]
}
function initPRSourceType()
{
	//{id:'11',text:'��ͬ�ܵ�'},{id:'12',text:'��ͬ��ϸ'},{id:'13',text:'������ϸ'},{id:'14',text:'�����ϸ'},{id:'15',text:'�״γ�����ϸ(���Ƽ�)'},{id:'16',text:'�˻���ϸ'}
	//{id:'21',text:'ά����ͬ�ܵ�'},{id:'22',text:'ά����ͬ��ϸ'}
	//{id:'31',text:'������'},{id:'32',text:'�״��������(���Ƽ�)'},{id:'33',text:'����˻�'}
	//{id:'41',text:'����'}
	//{id:'51',text:'����'},{id:'52',text:'���'},{id:'53',text:'ά��'}
	var PRPayFromType=getElementValue("PRPayFromType")
	var PRSourceTypeData=[]
	if (PRPayFromType=="1")	{PRSourceTypeData=[{id:'11',text:'��ͬ�ܵ�'},{id:'12',text:'��ͬ��ϸ'},{id:'13',text:'������ϸ'},{id:'14',text:'�����ϸ'},{id:'16',text:'�˻���ϸ'}]}
	else if (PRPayFromType=="2"){PRSourceTypeData=[{id:'21',text:'ά����ͬ�ܵ�'},{id:'22',text:'ά����ͬ��ϸ'}]}
	else if (PRPayFromType=="3"){PRSourceTypeData=[{id:'31',text:'������'},{id:'33',text:'����˻�'}]}
	else if (PRPayFromType=="4"){PRSourceTypeData=[{id:'41',text:'����'}]}
	else if (PRPayFromType=="5"){PRSourceTypeData=[{id:'51',text:'����'},{id:'52',text:'���'},{id:'53',text:'ά��'}]}
	else if (PRPayFromType=="9"){
		var PRSourceTypeStr=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetPayCostType")
		var PRSourceTypeCount=PRSourceTypeStr.split("@")
		for (var i=0; i<PRSourceTypeCount.length; i++)
		{
			var OneInfo=new CustomData(PRSourceTypeCount[i])
			PRSourceTypeData.push(OneInfo)
		}
	}
	var PRSourceType = $HUI.combobox('#PRSourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:PRSourceTypeData,
		onSelect : function(){}
	});
}
function initPRPayFromType()
{
	var PRPayFromType = $HUI.combobox('#PRPayFromType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id: '1',text: '�¹��豸'}
//			{id: '2',text: 'ά����ͬ'},
//			{id: '3',text: '���'},
//			{id: '4',text: '���˸���'},
//			{id: '5',text: 'ά������'},
//			{id: '9',text: '��������'}
			],
		onSelect : function(){
			initPRSourceType()
			toolbarenable()
			}
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="PRProviderDR_VDesc")
	{
		setElement("PRProviderDR",rowData.TRowID)
		setElement("PRBank",rowData.TBank)
		setElement("PRBankAccount",rowData.TBankNo)
	}
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

/// add by zx 2020-03-31 BUG ZX0082
/// ����: ����ˢ�´���
/// ���: rowID ��������RowID
function reloadPage(rowID)
{
	var WaitAD=getElementValue("WaitAD"); 
	var QXType=getElementValue("QXType");
	var Type=getElementValue("Type");
	//if (rowID=="") Type="";
	var val="&PRRowID="+rowID+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
	url="dhceq.em.payrequest.csp?"+val
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}
 // add By QW20210422 BUG:QW0099 ����ͼƬ�ϴ�
function BPicture_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly")
	var PicQXType=getElementValue("QXType") 
	var Status=getElementValue("PRStatus");
	if (Status!=0) {ReadOnly=1}
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=76&CurrentSourceID='+getElementValue("PRRowID")+'&Status='+Status+'&ReadOnly='+ReadOnly+'&PicQXType='+PicQXType;
	showWindow(str,"ͼƬ��Ϣ","","","icon-w-paper","modal","","","large");
}
