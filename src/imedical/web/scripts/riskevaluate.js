jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	initUserInfo()  ////Modiedy by zc0057 ��ʼ���Ự����
	showBtnIcon('BEvaluate^BPreEvaluate^BReEvaluate',false); //modified by LMH 20230202 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonWidth();
	jQuery('#BEvaluate').bind('click', BEvaluate_Clicked)
	jQuery('#BReEvaluate').bind('click', BReEvaluate_Clicked)
	jQuery('#BPreEvaluate').bind('click', BPreEvaluate_Clicked)
	defindTitleStyle();
	initDHCEQRiskEvaluate();			//��ʼ�����
	FillData();
	SetEnabled();
}	
function BFind_Clicked()
{
	initDHCEQRiskEvaluate()
}
function initDHCEQRiskEvaluate()
{
	$HUI.datagrid("#tDHCEQRiskEvaluate",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.BUSEvaluate",
	        QueryName:"GetRiskEvaluate",
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
			RowID:getElementValue("RowID"),
	    },
	    singleSelect:true,
		//fitColumns:true,  //modified by LMH 20230203  ����ʱĬ���������
    	onClickRow: onClickRow,//�����Ԫ�񴥷��¼�
		columns:[[
			{field:'TRiskEvaluationListDR',title:'TRiskEvaluationListDR',width:50,align:'center',hidden:true},
			{field:'TRiskEvaluationDR',title:'TRiskEvaluationDR',width:50,align:'center',hidden:true},
			{field:'TRiskItemDR',title:'TRiskItemDR',width:50,align:'center',hidden:true},
			{field:'TRiskItem',title:'',width:200,align:'center'},
			{field:'TRiskItemValueDR',title:'TRiskItemValueDR',width:50,align:'center',hidden:true},
			{field:'TRiskItemValue',title:'��������',width:200,align:'center'},
			{field:'TWeights',title:'Ȩ��',width:100,align:'center'},
			{field:'TOpt',title:'ѡ��',width:100,align:'center',formatter: RadioOperation},
		]],
		onLoadSuccess: function (data) {                      //data��Ĭ�ϵı��������ݣ�����rows��Total
  		if (data.rows.length > 0) {
     		//����mergeCellsByField()�ϲ���Ԫ��
     		mergeCellsByField("tDHCEQRiskEvaluate", "TRiskItem");
  }
}


});
}
function FillData()
{
	var rowid=jQuery('#RowID').val()
	if (rowid=="") return ;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.BUSEvaluate',
			MethodName:'GetOneRiskEvaluate',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			jQuery('#RiskGradeDR').val(list[4]);
			jQuery('#Remark').val(list[8]);
			jQuery('#Result').val(list[14]);
			jQuery('#Score').val(list[3]);
		}
	});
}	
function RadioOperation(value,row,index){
		if(value=="Y"){
			return '<input type="radio" name="radio'+row.TRiskItemDR+'" checked="checked" value="'+row.TRiskItemValueDR+'">';
		}
		else{
		return '<input type="radio" name="radio'+row.TRiskItemDR+'" value="'+row.TRiskItemValueDR+'">';
		}

}
function SetEnabled()
{
	var ReadOnly=jQuery('#ReadOnly').val();
	var RowID=jQuery('#RowID').val();
	if (RowID=="")
	{
        jQuery('#BReEvaluate').hide();
        jQuery('#BReEvaluate').attr('disabled',"true")
        jQuery('#BPreEvaluate').hide();
        jQuery('#BPreEvaluate').attr('disabled',"true")
	}
	else
	{

		jQuery('#BEvaluate').hide();
		jQuery('#BEvaluate').attr('disabled',"true")
		if(ReadOnly!=0)
		{
			jQuery('#BReEvaluate').hide();
        	jQuery('#BReEvaluate').attr('disabled',"true")
        	jQuery('#BPreEvaluate').hide();
        	jQuery('#BPreEvaluate').attr('disabled',"true")
		}
	}
	
}
function BEvaluate_Clicked()
{
	var val=CombineData();	
    var valList=GetTableInfo();
    if (valList=="-1")  return;
    var Rtn=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SaveRiskEvaluate",val,valList);
    var list=Rtn.split("^");
	if(list[0]=="0") 
	{
		jQuery.messager.show({title: '��ʾ',msg: '����ɹ�'});
		var url="dhceq.em.riskevaluate.csp?&ReadOnly=0&RowID="+list[1]+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val();
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	} 
	else
	{
		$.messager.alert('����ʧ�ܣ�','�������:'+list[0], 'warning');
	}
    
}
function BReEvaluate_Clicked()
{
	var val=CombineData();	
    var valList=GetTableInfo();
    if (valList=="-1")  return;
    var Rtn=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SaveRiskEvaluate",val,valList);
    var list=Rtn.split("^");
	if(list[0]=="0") 
	{
		jQuery.messager.show({title: '��ʾ',msg: '����ɹ�'});
		"dhceq.em.riskevaluate.csp?&ReadOnly=0&RowID="+list[1]+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val();
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	} 
	else
	{
		$.messager.alert('����ʧ�ܣ�','�������:'+list[0], 'warning');
	}
}
function BPreEvaluate_Clicked()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SumRiskEvaluate",jQuery('#SourceType').val(),jQuery('#SourceID').val());
	if(Rtn<2)
	{
		jQuery.messager.show({title: '��ʾ',msg: 'ֻ������һ��'});
		return ;
	}
	var str="dhceq.em.riskevaluatehistory.csp?&RowID="+jQuery('#RowID').val()+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val()
	showWindow(str,"��ʷ������ϸ","","","","","","","middle"); //modify by lmm 2020-06-05 UI
}
function GetTableInfo()
{
	var j=0;
	var vNum=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SumRiskItem");
	if(vNum<1)
	{
		jQuery.messager.show({title: '��ʾ',msg: 'û�з���������Ŀ,�޷�����'});
		return -1;
	}
	var info=""
	jQuery('#tDHCEQRiskEvaluate').datagrid('getPanel').find(':radio:checked').each(function(i,val){
		if(info=="") 
		{
			info=val.value
		}
		else
		{
			info=info+"&"+val.value
		}
		j=i
	})
	if(j<vNum-1)  ////Modiedy by zc0057 �޸ļ�����������
	{
		jQuery.messager.show({title: '��ʾ',msg: '����������Ŀû��ȫ�����'});
		return -1;
	}
	return info;
}
function onClickRow()
{
	var list=""
	jQuery('#tDHCEQRiskEvaluate').datagrid('getPanel').find(':radio:checked').each(function(i,val){
		if(list=="") 
		{
			list=val.value
		}
		else
		{
			list=list+","+val.value
		}	
	})
	var res = tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "GetRiskGradeAndScore",list);
	var ret=res.split("^"); 
	if(jQuery('#ReadOnly').val()==0)
	{
		jQuery('#RiskGradeDR').val(ret[0]);
		jQuery('#Result').val(ret[1]);
		jQuery('#Score').val(ret[2]);
	}
}
function CombineData()
{
	var val="";
	val=jQuery('#RowID').val();
	val+="^^"+jQuery('#SourceType').val();
	val+="^"+jQuery('#SourceID').val();
	val+="^"+jQuery('#Score').val();
	val+="^"+jQuery('#RiskGradeDR').val();
	val+="^"+curUserID;   ////Modiedy by zc0057 ��Ӳ�����  
	val+="^^^"+jQuery('#Remark').val();
	return val;
}

function mergeCellsByField(tableID, colList) {
    var ColArray = colList.split(",");
    var tTable = $("#" + tableID);
    var TableRowCnts = tTable.datagrid("getRows").length;
    var tmpA;
    var tmpB;
    var PerTxt = "";
    var CurTxt = "";
    var alertStr = "";
    for (j = ColArray.length - 1; j >= 0; j--) {
        PerTxt = "";
        tmpA = 1;
        tmpB = 0;

        for (i = 0; i <= TableRowCnts; i++) {
            if (i == TableRowCnts) {
                CurTxt = "";
            }
            else {
                CurTxt = tTable.datagrid("getRows")[i][ColArray[j]];
            }
            if (PerTxt == CurTxt) {
                tmpA += 1;
            }
            else {
                tmpB += tmpA;
                
                tTable.datagrid("mergeCells", {
                    index: i - tmpA,
                    field: ColArray[j],
                    rowspan: tmpA,
                    colspan: null,
                });
                tTable.datagrid("mergeCells", { 
                    index: i - tmpA,
                    field: "Ideparture",
                    rowspan: tmpA,
                    colspan: null
                });
               
                tmpA = 1;
            }
            PerTxt = CurTxt;
        }
    }
}
