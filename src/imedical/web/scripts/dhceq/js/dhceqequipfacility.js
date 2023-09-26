//界面入口
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
}
//初始化查询头面板
function initTopPanel()
{
	initComboGridPanel();
	jQuery("#BSave").linkbutton({iconCls: 'icon-save'});
	jQuery("#BSave").on("click", BSave_Clicked);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-cancel'});
	jQuery("#BDelete").on("click", BDelete_Clicked);
	var RowID=jQuery("#rowid").val();
	FillDate(RowID);
}
function initComboGridPanel()
{
	jQuery("input[name='combogrid']").each(function() {
		var options=eval('(' + jQuery(this).attr("data-options") + ')');
		jQuery(this).initComboGrid(options);
	});
}
function BSave_Clicked()
{
	var ReqNum=0;
	jQuery('input.validatebox-invalid').each(function(){ ReqNum++});
	if (ReqNum>0) {
		jQuery.messager.alert("提示", "请检查必填字段！");
		return;
	}
	// add by zx 2017-09-01 ZX0044 
        if(jQuery('#itemdr').val()==""){
		jQuery.messager.alert("提示", "请选择设备！");
		return;
	}
	var CombineData=CombinData();
	jQuery.ajax({
	    async:false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQEquip',
			MethodName:'SaveData',
			Arg1:'',
			Arg2:'',
			Arg3:CombineData,
			Arg4:SessionObj.GUSERID,
			Arg5:'',
			Arg6:'2',
			ArgCnt:6
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			if(data>0)
			{
			 	var lnk="dhceq.process.equipfacility.csp?&rowid="+data;
				location.href=lnk;
			}
			else
			{
				// add by zx 2017-10-10 BUG 462173 设备编号录入重复时,新增和更新分别返回'-119'和'-120'
				if((data=="-119")||(data=="-120"))
				{
					jQuery.messager.alert("提示", "设备编号不唯一!");
				}
				else
				{
					jQuery.messager.alert("提示", "保存失败!");
				}
			}
		}
	});
}
function BDelete_Clicked()
{
	//add by kdf 2018-02-03 需求号：542226 ，增加确认删除提示框
	if(!confirm("确认删除数据吗?")){
		return ;
		}
		
	var RowID=jQuery("#rowid").val();
	jQuery.ajax({
	    async:false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQEquip',
			MethodName:'DelData',
			Arg1:'',
			Arg2:'',
			Arg3:RowID,
			Arg4:SessionObj.GUSERID,
			ArgCnt:4
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			if(data==0)
			{
			 	var lnk="dhceq.process.equipfacility.csp?&rowid=";
				location.href=lnk;
			}
			else
			{
				jQuery.messager.alert("提示", "删除失败!");
			}
		}
	});
}
function CombinData()
{	
	var combindata="";
	combindata=jQuery('#rowid').val();
  	combindata=combindata+"^"+jQuery("#item").combogrid("getText");
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#modeldr").val(); 
  	combindata=combindata+"^"+jQuery("#equipcatdr").val(); 
  	combindata=combindata+"^"+jQuery("#unitdr").val();;
  	combindata=combindata+"^"+jQuery("#code").textbox("getValue");
  	combindata=combindata+"^"+jQuery("#itemdr").val();;
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#leavefactoryno").textbox("getValue");
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	if (jQuery('#computerflag').is(':checked'))
  	{
	  	combindata=combindata+"^true";
	}else{
		combindata=combindata+"^false";
	}
  	combindata=combindata+"^"+jQuery("#countrydr").val();;
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	if (jQuery('#classflag').is(':checked')) //add by zx 2017-08-31 BUG ZX0043
  	{
	  	combindata=combindata+"^";
	}
  	else{
	  	combindata=combindata+"^"+jQuery("#uselocdr").val();
	}
  	
  	combindata=combindata+"^"+jQuery("#origindr").val();
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
    combindata=combindata+"^"+jQuery("#providerdr").val();;
  	combindata=combindata+"^"+jQuery("#manufactorydr").val();;
  	combindata=combindata+"^"+jQuery("#originalfee").numberbox('getValue');;
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#remark").val();
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#status").combogrid("getValue");
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#providerhandler").textbox("getValue");
  	combindata=combindata+"^"+jQuery("#providertel").textbox("getValue");
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery('#startdate').datebox('getText');  //add by zx 2017-11-10 日期格式转换去掉 Bug ZX0048 需求号:479138
  	combindata=combindata+"^"+jQuery('#transassetdate').datebox('getText');
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#equiptypedr").val();
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#keeperdr").val();
  	combindata=combindata+"^"+jQuery("#uselocdr").val();
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#equipno").textbox("getValue");
  	combindata=combindata+"^"+jQuery("#locationdr").val();;
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#statcatdr").val();
  	combindata=combindata+"^"+jQuery("#contractno").textbox("getValue");
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	if (jQuery('#classflag').is(':checked'))
  	{
	  	combindata=combindata+"^true";
	}else{
		combindata=combindata+"^false";
	}
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#fileno").textbox("getValue");
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^"+jQuery("#item").combogrid("getText");
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	if (jQuery('#raditionflag').is(':checked'))
  	{
	  	combindata=combindata+"^true";
	}else{
		combindata=combindata+"^false";
	}
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	combindata=combindata+"^";
  	
 	return combindata;
}
//泛类无使用科室
jQuery("#classflag").click(function()
{
	UseLocRequiredChange()		//modified by czf 575959
});
//设备项选择获取相关信息
function GetItemValue()
{
	var RowID=jQuery('#itemdr').val();
	if(RowID==="") return;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQCMasterItem',
			MethodName:'GetDocByID',
			Arg1:'',
			Arg2:'',
			Arg3:RowID,
			ArgCnt:3
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			jQuery("#code").textbox('setValue',list[1]);
			jQuery("#equiptypedr").val(list[3]);
			jQuery("#equiptype").textbox('setValue',list[4]);
			jQuery("#statcatdr").val(list[7]);
			jQuery("#statcat").textbox('setValue',list[8]);
			jQuery("#equipcatdr").val(list[5]);
			jQuery("#equipcat").textbox('setValue',list[6]);
			jQuery("#unitdr").val(list[10]);
			jQuery("#unit").combogrid('setText',list[11]);
		}
	});
}
//设备相关信息
function FillDate(RowID)
{
	if(RowID=="") return;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQEquip',
			MethodName:'GetEquipByID',
			Arg1:'',
			Arg2:'',
			Arg3:RowID,
			ArgCnt:3
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			jQuery("#item").combogrid('setValue',list[6]);		//modified by czf 575964 begin
			jQuery("#item").combogrid('setText',list[131]);
			jQuery("#itemdr").val(list[6]);
			jQuery("#code").textbox('setValue',list[5]);
			jQuery("#equipno").textbox('setValue',list[70]);
			jQuery("#model").combogrid('setValue',list[2]);
			jQuery("#model").combogrid('setText',list[95]);
			jQuery("#modeldr").val(list[2]);
			jQuery("#status").combobox('setValue',list[37]);
			jQuery("#useloc").combogrid('setValue',list[18]);
			jQuery("#useloc").combogrid('setText',list[102]);
			jQuery("#uselocdr").val(list[18]);
			jQuery("#country").combogrid('setValue',list[15]);
			jQuery("#country").combogrid('setText',list[99]);
			jQuery("#countrydr").val(list[15]);
			//jQuery("#classflag").val(list[81]);
			if(list[82]=="1") jQuery("#classflag").attr("checked",true); //add by zx 2017-08-31 BUG ZX0043
			jQuery("#equiptypedr").val(list[62]);
			jQuery("#equiptype").textbox('setValue',list[117]);
			jQuery("#statcatdr").val(list[74]);
			jQuery("#statcat").textbox('setValue',list[126]);
			jQuery("#equipcatdr").val(list[3]);
			jQuery("#equipcat").textbox('setValue',list[96]);
			jQuery("#unit").combogrid('setValue',list[4]);
			jQuery("#unit").combogrid('setText',list[97]);
			jQuery("#unitdr").val(list[4]);
			jQuery("#manufactory").combogrid('setValue',list[25]);
			jQuery("#manufactory").combogrid('setText',list[108]);
			jQuery("#manufactorydr").val(list[25]);
			jQuery("#leavefactoryno").textbox('setValue',list[9]);
			jQuery("#origin").combogrid('setValue',list[19]);
			jQuery("#origin").combogrid('setText',list[103]);
			jQuery("#origindr").val(list[19]);
			jQuery("#originalfee").numberbox('setValue',list[26]);
			jQuery("#provider").combogrid('setValue',list[24]);
			jQuery("#provider").combogrid('setText',list[107]);
			jQuery("#providerdr").val(list[24]);
			jQuery("#providerhandler").textbox('setValue',list[40]);
			jQuery("#providertel").textbox('setValue',list[41]);
			jQuery("#contractno").textbox('setValue',list[75]);
			jQuery("#fileno").textbox('setValue',list[84]);
			jQuery("#transassetdate").datebox('setValue',list[44]);
			jQuery("#transassetdate").datebox('setText',list[44]); //modify by lmm 2017-09-26 455437
			jQuery("#location").combogrid('setValue',list[71]);
			jQuery("#location").combogrid('setText',list[129]);
			jQuery("#locationdr").val(list[71]);
			jQuery("#keeper").combogrid('setValue',list[65]);	//modified by czf 575964 end
			jQuery("#keeper").combogrid('setText',list[120]);
			jQuery("#keeperdr").val(list[65]);
			jQuery("#advancedisflag").textbox('setValue',list[92]);
			jQuery("#startdate").datebox('setValue',list[43]);
			jQuery("#startdate").datebox('setText',list[43]);   //modify by lmm 2017-09-26 455437
			jQuery("#date").datebox('setText',list[43]);   //modify by lmm 2017-09-26 455437
			//jQuery("#computerflag").val(list[14]);
			//jQuery("#raditionflag").val(list[145]);
			if(list[14]=="1") jQuery("#computerflag").attr("checked",true); //add by zx 2017-08-31 BUG ZX0043
			if(list[145]=="1") jQuery("#raditionflag").attr("checked",true); //add by zx 2017-08-31 BUG ZX0043
			jQuery("#remark").val(list[33]);
			UseLocRequiredChange();	//Add by czf 575959
		}
	});
}
function changeDateformat(Date)
{
	if (Date=="") return "";
	var date=Date.split("-")
	var temp=date[2]+"/"+date[1]+"/"+date[0];   //日期格式变换
	return temp;
}

//Add by czf 575959
function UseLocRequiredChange()
{
	var obj=jQuery("#useloc").next().children("input.validatebox-text")
	if (jQuery("#classflag").is(':checked')) {
		jQuery("#useloc").next().attr("class","textbox combo")
		obj.attr("class","textbox-text validatebox-text textbox-prompt")
		jQuery("#useloc").combogrid('disable');
	}else{
		if(jQuery("#useloc").combogrid('getValue')==""){
			jQuery("#useloc").next().attr("class","textbox textbox-invalid combo")
			obj.attr("class","textbox-text validatebox-text validatebox-invalid textbox-prompt")
		}
		jQuery("#useloc").combogrid('enable');
	}
}