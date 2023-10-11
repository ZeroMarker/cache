var editIndex=undefined;
var Columns=getCurColumnsInfo('EM.G.Equip.UpdateEquipsByList','','','');
$(function(){
	initDocument();
	if (getElementValue("Status")>0) disableElement("update",true);	// Mozy	814677	2019-1-24	�Է�����״̬ת�Ƶ����豸��������б�ĸ��½�����Ч����
});
function initDocument()
{
	$HUI.datagrid("#DHCEQUpdateEquipsByList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSUpdateEquipByList",
			QueryName:"GetEquipsByMove",
			SourceID:getElementValue("SourceID"),
			QuantityNum:getElementValue("QuantityNum"),
			Job:getElementValue("Job"),
			index:getElementValue("Index"),
			MXRowID:getElementValue("MXRowID"),
			StoreLocDR:getElementValue("StoreLocDR"),
			Type:getElementValue("Type"),
			EquipID:getElementValue("EquipID")
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    toolbar:[
		    {
				iconCls: 'icon-save',
	            text:'����',
	            id:'update',       
	            handler: function(){
	                 updateRow();
	            }
	        }
        ],
		fitColumns:true,   //add by lmm 2020-06-02
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
}
function onClickRow(index)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQUpdateEquipsByList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQUpdateEquipsByList').datagrid('getRows')[editIndex]);
		} else {
			$('#DHCEQUpdateEquipsByList').datagrid('selectRow', editIndex);
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
	if ($('#DHCEQUpdateEquipsByList').datagrid('validateRow', editIndex)){
		$('#DHCEQUpdateEquipsByList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
/*
function updateRow()
{
	if (editIndex != undefined){ $('#DHCEQUpdateEquipsByList').datagrid('endEdit', editIndex);}
	var rows = $("#DHCEQUpdateEquipsByList").datagrid("getRows");
	var listInfos="";
	for(var i=0;i<rows.length;i++)
	{
		var listInfo=rows[i].TRowID+"^"+rows[i].TLeaveFactoryNo;
		if(rows[i].TSelect=="Y")
		{
			if (listInfos=="")
			{
				listInfos=listInfo;
			}
			else 
			{
				listInfos=","+listInfos+",";
				if (listInfos.indexOf(","+listInfo+",")<0)
				{
					listInfos=listInfos+listInfo+",";
				}
				listInfos=listInfos.substring(1,listInfos.length - 1);
			}
		}
	}
	if (listInfos=="") return;
	var rtn=CheckLeaveFactoryNo(listInfos);
	if (rtn!="1") return;
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSUpdateEquipByList","UpdateLeaveFactoryNo",listInfos);
	if (result==0)
	{
		location.reload();
	}
	else
	{
		messageShow('alert','error','��ʾ',"����ʧ��!");
	}
}
*/
function updateRow()
{	
	if (editIndex != undefined){ $('#DHCEQUpdateEquipsByList').datagrid('endEdit', editIndex);}
	var SourceID=getElementValue("SourceID");
	if (SourceID=="") 
	{
		messageShow('alert','error','��ʾ',"�豸����Ϊ1�������޸�");
		return;
	}
	var rows = $("#DHCEQUpdateEquipsByList").datagrid("getRows");
	var TJob=rows[0].TJob;
	setElement("Job",TJob);
	
	var job=getElementValue("Job");
	var index=getElementValue("Index");
	var mXRowID=getElementValue("MXRowID");
	var type=getElementValue("Type");
	var sourceID=getElementValue("SourceID");
	var storeLocDR=getElementValue("StoreLocDR");
	var quantityNum=getElementValue("QuantityNum");
	
	var listInfos=tkMakeServerCall("web.DHCEQ.EM.BUSUpdateEquipByList","GetEquipIDsInfo",type,mXRowID,storeLocDR,sourceID,quantityNum,job,index);
	var list=listInfos.split("&");
	listInfos=list[1];
	var totalNum=0
	var UpdateLeaveFactoryNoVals = "" //add by csj 20190125
	var UpdateLeaveFactoryNoVal = "" //add by csj 20190125
	for (i=0;i<rows.length;i++)
	{
		$('#DHCEQUpdateEquipsByList').datagrid('endEdit', i) //add by csj 20190125
		var TRowID=rows[i].TRowID;
		var listInfo=TRowID;
		var TSelect=rows[i].TSelect;
		var TLeaveFactoryNo=rows[i].TLeaveFactoryNo; //add by csj 20190125
		///modified by ZY0266 20210531
		var TFileNo=rows[i].TFileNo;
		//modified by ZY20230209 bug:  ���Ӿɱ�Ŵ���
		var TOldNo=rows[i].TOldNo;
		UpdateLeaveFactoryNoVal = TRowID+"^"+TLeaveFactoryNo+"^"+TFileNo+"^"+TOldNo
		if(UpdateLeaveFactoryNoVals == ""){
			UpdateLeaveFactoryNoVals = UpdateLeaveFactoryNoVal //add by csj 20190125
		}else{
			UpdateLeaveFactoryNoVals = UpdateLeaveFactoryNoVals + "," + UpdateLeaveFactoryNoVal //add by csj 20190125
		}
		if(TSelect=="Y") totalNum++;
		var tmp=","+listInfos+",";
		if (tmp.indexOf(","+listInfo+",")==-1)
		{
			if (TSelect=="Y")
			{
				if (listInfos!="") listInfos=listInfos+",";
				listInfos=listInfos+listInfo;
			}			
		}
		else
		{
			if (TSelect=="N")
			{
				tmp=tmp.replace(","+listInfo+",",",")
				//ת�Ƶ���?���������ϸת��ʱ?ѡ���豸��ʱ��ʾ���������?ֻѡ��һ̨�豸?Ȼ��ȡ����ѡ����������
				if (tmp==",")
				{	listInfos="";	}
				else
				{	listInfos=tmp.substring(1,tmp.length - 1) }
			}
		}		
	}	
	var Num=0
	if ((listInfos!="")&&(listInfos!=","))
	{
		var list=listInfos.split(",")
		Num=list.length
	}
	var truthBeTold = true;
	var Rnt=Num-quantityNum;
	//Modified by QW20210615 ������ʾ�޸� BUG:QW0123 Begin
	if (Rnt<0)
	{
		messageShow("confirm","info","��ʾ","ѡ����豸��������"+-Rnt+"̨,�Ƿ��޸�?","",function(){
			UpdateData(UpdateLeaveFactoryNoVals,Num,totalNum,listInfos);
		},function(){
			return
		});
	}
	else if (Rnt>0)
	{
		messageShow("confirm","info","��ʾ","ѡ����豸��������"+Rnt+"̨,�Ƿ��޸�?","",function(){
			UpdateData(UpdateLeaveFactoryNoVals,Num,totalNum,listInfos);
		},function(){
			return
		});
	}	///add by ZY0279 20210907
	else
	{
		UpdateData(UpdateLeaveFactoryNoVals,Num,totalNum,listInfos);
	}
	//Modified by QW20210615 ������ʾ�޸� BUG:QW0123 End
}
///modified by ZY0279 20210907
//add by QW20210615 ������ʾ�޸� BUG:QW0123
function UpdateData(UpdateLeaveFactoryNoVals,Num,totalNum,listInfos)
{
	///add by ZY0279 20210907
	///type=1 ��ת�ƣ�2�Ǽ����˻�
	var BussType=getElementValue("Type");
	if (BussType!=2)
	{
		//satrt by csj 20190125 ��������ţ��޸ĳ������
		var rtn=CheckLeaveFactoryNo(UpdateLeaveFactoryNoVals);
		if (rtn!="1") return;
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSUpdateEquipByList","UpdateLeaveFactoryNo",UpdateLeaveFactoryNoVals);
		if (result!=0){
			messageShow('alert','error','��ʾ',"������Ÿ���ʧ��!");
		}
		//end by csj 20190126 �޸ĳ������
	}
	
	var job=getElementValue("Job");
	var index=getElementValue("Index");
	var mXRowID=getElementValue("MXRowID");
	//var type=getElementValue("Type");
	var storeLocDR=getElementValue("StoreLocDR");
	var sourceID=getElementValue("SourceID");
	var MXInfo=job+"^"+index+"^"+Num+"^"+mXRowID+"^"+BussType;
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSUpdateEquipByList","UpdateEquipsByList",listInfos,MXInfo);
	if (result==0)
	{
		if (BussType<6)
		{
			websys_showModal("options").mth(index,totalNum);  //modify by lmm 2019-02-19
		}

		var val="&Job="+job;
		val=val+"&Index="+index;
		val=val+"&SourceID="+sourceID;
		val=val+"&MXRowID="+mXRowID;
		val=val+"&QuantityNum="+Num;
		val=val+"&StoreLocDR="+storeLocDR;
		val=val+"&Status="+getElementValue("Status");
		val=val+"&Type="+BussType;
		val=val+"&EquipID="+getElementValue("EquipID");
		var url= 'dhceq.em.updateequipsbylist.csp?'+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
	{
		messageShow('alert','error','��ʾ',"����ʧ��!");
	}
}

function CheckLeaveFactoryNo(value)
{
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSUpdateEquipByList","CheckLeaveFactoryNo",value);
	if (result!=0)
	{
		var list=result.split("^");
		var msg="";
		if (list[0]=="1")
		{	msg="�����µĳ�����������ظ����:"+list[1];}
		else
		{	msg="�����豸ʹ�ô˳������:"+list[1];		}
		
		var truthBeTold = window.confirm(msg+",�Ƿ�������±���?");
    	if (!truthBeTold) return 0;
	}
	return 1;
}
///add by lmm 2020-04-02 LMM0069
function checkboxSelectChange(TSelect,rowIndex)
{
	var row = jQuery('#DHCEQUpdateEquipsByList').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TSelect==key)
			{
				if (((val=="N")||val=="")) row.TSelect="Y"
				else row.TSelect="N"
			}
		})
	}
}
