Array.prototype.indexOf = function(val) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == val) return i;
	}
	return -1;
};
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
var selectItems = new Array();
var columns=getCurColumnsInfo('BA.G.BenefitEquipList.GetBenefitEquip','','','','N');  /// �޸�ҳ�治��ʾ�����
var frozencolumns=getCurColumnsInfo('BA.G.BenefitEquipList.GetBenefitEquip','','','','Y');  /// �޸�ҳ�治��ʾ�����
var nameConditionLimit=1   
var conditionFlag=0;  
jQuery(document).ready
( 
	function()
	{

		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initTopPanel();
	initStatusData();	
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	//��ֵԪ�ض���onchange�¼�,��У����Ч��
	initNumElement("MinValue^MaxValue");
	initLookUp();
	initButtonWidth();
	initButton();
	defindTitleStyle();
	if (getElementValue("UseLocDR")!="")
    {
	    var UseLoc=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID",'dept',getElementValue("UseLocDR"));
	    setElement("UseLoc",UseLoc)
	}
	initDHCEQEquipList();			//��ʼ�����
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(elementID)
{
	setElement(elementID+"DR","")
}
/// ״̬����������ȫ��״̬
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '�ڿ�'
			},{
				id: '1',
				text: '����'
			},{
				id: '2',
				text: 'ͣ��'
			}]
	});
}

function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});

		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		messageShow('popover','error','��ʾ',"����ȷ������ֵ!")
		return
	}
}
function initDHCEQEquipList()
{
	$HUI.datagrid("#tDHCEQBenefitEquip",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",   
	        QueryName:"GetBenefitEquip",
	        Data:"^InitFlag=Y",	
	        ReadOnly:getElementValue("ReadOnly"),
	        //Ejob:getElementValue("Job"),    // ̨�����job�Զ��û���������
	    },
	    fit:true,
		striped : true,
	    cache: false,
		fitColumns:false,		
    	columns:columns, 
    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:"", 
    	// ������ɫ
    	rowStyler: function(index,row){
			return 'background-color:'+row.TBackgroundColor;
		},
});
}
/***************************************��ť���ú���*****************************************************/
function BFind_Clicked()
{
	var lnk=GetLnk()
	$HUI.datagrid("#tDHCEQBenefitEquip",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",  
	        QueryName:"GetBenefitEquip",
	        Data:lnk,
	        ReadOnly:getElementValue("ReadOnly"),
	       // Ejob:getElementValue("Job"),       // ̨�����job�Զ��û���������
	    },
	    });
	selectItems.splice(0,selectItems.length); 
	jQuery('#tDHCEQBenefitEquip').datagrid('unselectAll') 
	InfoStr="";  
}

function GetLnk()
{
	var lnk="";
	lnk=lnk+"^No="+getElementValue("No");
	lnk=lnk+"^Name="+getElementValue("Name");
	lnk=lnk+"^UseLocDR="+getElementValue("UseLocDR");
	lnk=lnk+"^MinValue="+getElementValue("MinValue");
	lnk=lnk+"^MaxValue="+getElementValue("MaxValue");
	lnk=lnk+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"^ProviderDR="+getElementValue("ProviderDR");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	//�豸���Բ�ѯ
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var EquipAttributeString=""
	if ((SelectType)||(SelectType!=undefined))
	{
		var i=SelectType.length;
		var EquipAttributeString=""
		for (var j=0;j<i;j++)
		{
			if(EquipAttributeString=="")
			{
				EquipAttributeString=SelectType[j].id
			}else
			{
				EquipAttributeString=EquipAttributeString+getElementValue("SplitNumCode")+SelectType[j].id
			}
		}
	}
	lnk=lnk+"^EquipAttributeString="+EquipAttributeString
	return lnk
}
function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#tDHCEQBenefitEquip').datagrid('selectRecord', selectItems[i]); //����idѡ���� 
        }
}

//�ж�ѡ�м�¼��ID�Ƿ��Ѵ���checkedItems���������
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
//��ѡ�м�¼��ID�Ǵ洢checkedItems���������
function addselectItem(rowIndex, rowData) {
        //var row = jQuery('#tDHCEQBenefitEquip').datagrid('getSelections');
	    var rowid=rowData.TRowID;
	    /// modefied by by zc 2017-06-25 ZC0031 begin
	    var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');
	    var ret=res.split("^");
	    if (ret[0]!="0")
		{
		    $.messager.popover({msg:ret[1],type:'alert'});
		    $('#tDHCEQBenefitEquip').datagrid('unselectRow', rowIndex);
		}
		/// modefied by by zc 2017-06-25 ZC0031 end
		if (ret[0]=="0")
		{
        	for (var i = 0; i < row.length; i++) {
            	if (findSelectItem(row[i].TRowID) == -1) {
                	selectItems.push(row[i].TRowID);
            	}
        	}
		}
}
//�������ѡ�м�¼��ID
function removeAllItem(rows) {
        for (var i = 0; i < rows.length; i++) {
            var k = findSelectItem(rows[i].TRowID);
            if (k != -1) {
                selectItems.splice(i, 1);
            }
        }
}
//�������ѡ�м�¼��ID
function removeSingleItem(rowIndex, rowData) {
        var k = findSelectItem(rowData.TRowID);
        if (k != -1) {
            selectItems.splice(k, 1);
        }
}
function BSelectAll_Click() //ȫѡ
{
	messageShow('popover','alert','��ʾ',"��ǰҳ��δ��ѡ�е��豸������ҵ�񵥾�ռ��")
	jQuery('#tDHCEQBenefitEquip').datagrid('selectAll');
}
function BUnSelectAll_Click() //ȡ��ȫѡ
{
	selectItems.splice(0,selectItems.length);
	jQuery('#tDHCEQBenefitEquip').datagrid('unselectAll');
}

//Modify By zx 2020-02-20 BUG ZX0076
$("#ChooseCondition").popover({trigger:'manual',placement:'bottom',content:'<table><tr><td><input type="radio" name="condition" value="2"></td><td>����</td></tr><tr><td><input type="radio" name="condition" value="1" checked></td><td>����</td></tr><tr><td><input type="radio" name="condition" value="0"></td><td>����</td></tr></table>'});
$("#ChooseCondition").click(function(){
	$("#ChooseCondition").popover('show');
	if(conditionFlag==0)
	{
		$('input[name="condition"]').click(function(){
	   		nameConditionLimit=$("input[name='condition']:checked").val();
	   		$("#ChooseCondition").popover('hide');
	   		$("#ChooseCondition").text($(this).parent().next().text());
		});
	}
	conditionFlag=1;
});

//���豸�嵥�б���Ч���豸
function BSave_Clicked()
{	
var checkedItems = $('#tDHCEQBenefitEquip').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','��ʾ',"δѡ���豸��")
		return false;
	}
	var Listdatas=selectItems.toString()
  	var data=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveEquipData",Listdatas);
	data=data.replace(/\ +/g,"")	//ȥ���ո�
	data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
	data=data.split("^");
	var num=data[0];
	var errmesg=data[1];
	if (errmesg=="")
	{
			messageShow('popover','info','��ʾ',"��������Ч���豸�ɹ�,����"+num+"̨Ч���豸")
			websys_showModal("options").mth();
			jQuery('#tDHCEQBenefitEquip').datagrid('reload');
	}
	else
	{
		if (num!="0")
		{
				messageShow('popover','info','��ʾ',"����Ч���豸����"+num+"̨,�б��Ϊ"+errmesg+"Ч���豸����ʧ��")
	            websys_showModal("options").mth();
	            jQuery('#tDHCEQBenefitEquip').datagrid('reload');

		}
		else
		{
			messageShow('popover','error','��ʾ',"Ч���豸����ʧ��")
			return;
		}
	}

}