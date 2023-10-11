

//js����:DHCPECommon.hisui.js

//add by xy 2019-05-27
///������hisui��ȡĬ�ϵ���ʱ�� 
function getDefStDate(space) {
	if (isNaN(space)) {
		space = -30;
	}
	var dateObj = new Date();
	dateObj.setDate(dateObj.getDate() + space);
	var myYear = dateObj.getFullYear();
	var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
	var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
	var dateStr = "";
	var sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false); //ͬ������ȡϵͳ�������ڸ�ʽ
	if (sysDateFormat == 1) {
		dateStr = myMonth + '/' + myDay + '/' + myYear;
	} else if (sysDateFormat == 3) {
		dateStr = myYear + '-' + myMonth + '-' + myDay;
	} else {
		dateStr = myDay + '/' + myMonth + '/' + myYear;
	}

	return dateStr;
}
///add by xy 2020-03-13
///���������hisui���� �б���checkboxԪ�ز��ܱ༭
///���: ComponentName: ����� Item:ͼ�����ڵ�Ԫ����
function DiaabledTableIcon(ComponentName,Item)
{ 
	if ((ComponentName=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
	    
		var panel = $("#"+ComponentName).datagrid("getPanel");
		var index=i
			$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().attr("disabled", true);

    }
	
}


///add by xy 2018-09-07
///������hisui���� ���ر��ͼ�꣬���������غϼ���ͼ�� 
///���: ComponentName:	�����    val:��ӦԪ��ֵΪ�������ظ�ͼ��   Item:ͼ�����ڵ�Ԫ����
function hiddenTableIcon(ComponentName,val,Item)
{   
	if ((ComponentName=="")||(val=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
	    
		var panel = $("#"+ComponentName).datagrid("getPanel");
		var index=i
		var obj = panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+val+"] div");
		if (obj.html()=="")
		{
			$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().hide()  //���html("")�޷�����CheckBox������

		}
    }
	
}


///add by xy 2018-09-06
///������hisui����  ��ť�һ�/���ô���
///���:vElementID Ԫ������,vValue:true �һ� ���� 
function DisableBElement(vElementID,vValue)
{ 
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//��ť�һ�
			jQuery("#"+vElementID).linkbutton("disable")
		
		}
		else
		{
			//��ť����
			jQuery("#"+vElementID).linkbutton("enable")
			
		}
	}
}


///add by xy 2018-09-05
///������hisui����  ��ť�����޸�
///���:ename  Ԫ������,evalue  ���޸ĵ�ֵ
function SetCElement(ename,evalue)
{
	
	var obj;
	obj=document.getElementById(ename);
	if(obj){jQuery("#"+ename).linkbutton({text:evalue});}
}

///add by xy 2018-09-04
///������hisui���� ��ť��̳���Ϊ���֣��������ť�������а�ť����
///���:vExcludesids ��ʼ������Ԫ�� ��ʽ"Ԫ����1,Ԫ����2,....Ԫ����n"
function initButtonWidth(vExcludesids,minlen,subwidth)
{
	
	var minlen=4//��̿�� ���ֳ� 116px
	var subwidth="140px"  
	var middlelen=""
	var IdArr=[];
	//������ťid��������
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		//console.log(id);
		IdArr.push(id)
		
	})
	
	for(i=0;i<IdArr.length;i++)
	{
		var len=getValueById(IdArr[i]).length
		if (middlelen=="")
		{
			var middlelen=minlen
		}
		if(len>middlelen)
		{
			var middlelen=len
			var subwidth=$("#"+IdArr[i]).css("width")
		}
		
	}
	for(i=0;i<IdArr.length;i++)
	{
		if ((","+vExcludesids+",").indexOf(","+IdArr[i]+",")==-1)
		{
			$("#"+IdArr[i]).css({"width":subwidth})
		}
		
	}
	
}	
///add by wgy 2020-03-26
///���������hisui���� �б���checkboxԪ�ز��ܱ༭
///���: ComponentName: ����� Item:ͼ�����ڵ�Ԫ����
function DisabledTableCheckbox(ComponentName,Item)
{ 
	if ((ComponentName=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
	    
		var panel = $("#"+ComponentName).datagrid("getPanel");
		//$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+Item+"] .datagrid-cell input[type=checkbox]").attr("disabled", "disabled");
		var checkObj=$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+Item+"] .datagrid-cell td")[0];
		if(checkObj){
			var checked="";
			if(checkObj.children[0] && checkObj.children[0].value=="1"){
				checked="checked";
			}
			var oldContent=checkObj.innerHTML;
			var newContent=oldContent.replace("<input","<input disabled "+checked);
			checkObj.innerHTML=newContent;
		}
		
    }
	
}	
function PEURLAddToken(url) {
    return 'function' === typeof websys_writeMWToken ? websys_writeMWToken(url) : url;
}