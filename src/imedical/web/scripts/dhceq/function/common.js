//Create By JDL 20151020 增加一些常用的公共处理方法及函数
//====================================================================

var QueryFlag=true;
var SplitChar="^";


//获取CheckBox的值,选中返回"Y",否则返回"N"
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"N";
}

//设置CheckBox的值,入参value为"Y"或"N"
function SetCheckValue(checkName,value)
{
	jQuery("#" + checkName).prop("checked",value=="Y"?true:false);
}
///modify by lmm 2019-02-19 827382 更改旧easyui界面弹窗居中问题 默认80%
function OpenNewWindow(url,showInNewWindow)
{
	
	var iWidth=window.screen.width*0.8;                         //弹出窗口的宽度;
	var iHeight=window.screen.height*0.8;                        //弹出窗口的高度;
	var iTop = (window.screen.height-iHeight)/2;       //获得窗口的垂直位置;
	var iLeft = (window.screen.width-iWidth)/2;        //获得窗口的水平位置;
	
	//window.open(url,'_blank',',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0');
	window.open(url,'_blank',',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+iWidth+',height='+iHeight+',left='+iLeft+',top='+iTop);
}

//重新装载数据 Add JDL 20151020
//DataGridID :Grid的id
//ExpStr: 文本框中的文本
//Args:参数串，Arg1^Arg2^Arg3..... ,暂时写3个，更多时再扩展  
// 注意：对应的js中，必要的还需 重写 InitCboGrid方法
function ReloadGrid(DataGridID,ExpStr,Args)
{
	//如第一次初始化，则已经加载数据，不需再加载
	QueryFlag=true;	
	InitCboGrid(DataGridID);
//	messageShow("","","",ExpStr+QueryFlag);
	if (QueryFlag==false) return;
	//alertShow("ReloadGrid:"+DataGridID+"  Args:"+Args);
	var jQueryGridObj = jQuery("#" + DataGridID).combogrid('grid');	
//	var url=jQueryGridObj.datagrid('options').url;
//	if (url.indexOf("_t=") > 0) {  
//    	url = url.replace(/_t=\d+/, "_t=" + new Date().getTime());  
//	} 
//	else {  
//	    url = url.indexOf("?") > 0  
//	        ? url + "&_t=" + new Date().getTime()  
//	        : url + "?_t=" + new Date().getTime();  
//	}  
//	jQueryGridObj.datagrid('options').url=url;
	var queryParams =jQueryGridObj.datagrid('options').queryParams;
	
	var ArgList=Args.split(SplitChar)
	var i=0;
	for (i=0;i<ArgList.length;i++)
	{
		//messageShow("","","",i+"="+ArgList[i]);
		if (i==0)
			{	queryParams.Arg1 =ArgList[i];}
		else if (i==1)
			{	queryParams.Arg2 =ArgList[i];}
		else if (i==2)
			{	queryParams.Arg3 =ArgList[i];}
		else
			{	alertShow("参数过多！");}			
	}
	
    jQueryGridObj.datagrid('options').queryParams = queryParams;
    jQueryGridObj.datagrid('reload');
    //setTimeout("alertShow('0.5 seconds!')",500)
    jQuery("#" + DataGridID).combogrid("setValue", ExpStr);	
}

///留有此虚方法,待实际js中重写 可参考dhceqcmanagelimit.js
function InitCboGrid(DataGridID)
{
}

///通过Ajax调用后台方法
///data:样例
///		var data={
///	                ClassName:"web.DHCEQCManageLimit",
///	                MethodName:"DeleteManageLimit",
///	                Arg1:$('#Rowid').val(),
///	                ArgCnt:1
///	            };
///beforeSendMsg：进度条提示信息
///action:字符串，用于区分为何方法调用
function DoAjaxAction(data,beforeSendMsg,action)
{
	$.ajax({
        url :"dhceq.jquery.method.csp",
        type:"POST",
        data:data,
        beforeSend: function () {
	        if (beforeSendMsg!="") $.messager.progress({text: beforeSendMsg	});
        	},
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
                },
        success:function (data, response, status) {
	        if (beforeSendMsg!="") $.messager.progress('close');
        	DoAjaxResult(data, response, status,action)
       		}
    })	
}


///调用后台DoAjaxAction，执行结果成功时，根据data做相应处理
///留有此虚方法,待实际js中重写 可参考dhceqcmanagelimit.js
function DoAjaxResult(data, response, status,action)
{
}
///add by zy 2017-4-6  ZY0162
///创建组件元素对象
///入参：itemID  	DHC_EQCComponentItem表的ID
///		 itemSetID  DHC_EQCComponentSetItem表的ID
///把取到的元素信息放在对象中。
function ComponentItem(itemID,itemSetID)
{
	var list=""
    $.ajax({
	    	async:false,
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCComponentSet",
                MethodName:"GetComponentOneItem",
		        	Arg1:itemID,
					Arg2:itemSetID,
			        ArgCnt:2
            },
            success:function (data, response, status) {
				data=data.replace(/\ +/g,"")	//去掉空格
				data=data.replace(/[\r\n]/g,"")	//去掉回车换行
				if (data=="")
				{
					$.messager.alert('创建组件元素对象失败','', 'warning');
					return;
				}else
				{
					list=data
				}
				
            }
    });
    if (list=="")return;
	var list=list.split("^");
	this.Name=list[1];
	this.Caption=list[2];
	this.CaptionStyle=list[3];
	this.ClassMethod=list[4];
	this.ClassMethodIfDirty=list[5];
	this.CustomExpression=list[6];
	this.DataType=list[7];
	this.DefaultValueAlways=list[8];
	this.DefaultValueExpression=list[9];
	this.Description=list[10];
	this.Disabled=list[11];
	this.DisplayOnly=list[12];
	this.DisplayType=list[13];
	this.HelpUrl=list[14];
	this.Hidden=false
	if (list[15]=="true") this.Hidden=true
	this.Image=list[16];
	this.LinkComponent=list[17];
	this.LinkConditionalExp=list[18];
	this.LinkExpression=list[19];
	this.LinkUrl=list[20];
	this.LinkWorkFlow=list[21];
	this.ListCellStyle=list[22];
	this.LookupBrokerMethod=list[23];
	this.LookupClassName=list[24];
	this.LookupCustomComponent=list[25];
	this.LookupJavascriptFunction=list[26];
	this.LookupProperties=list[27];
	this.LookupQueryName=list[28];
	this.LookupUserDefined=list[29];
	this.LookupUserDefinedValues=list[30];
	this.NestedComponent=list[31];
	this.NestedCondExpr=list[32];
	this.OrderMode=list[33];
	this.Password=list[34];
	this.ReadOnly=list[35];
	this.ReferencedObject=list[36];
	this.Required=list[37];
	this.ShortcutKey=list[38];
	this.ShowInNewWindow=list[39];
	this.Style=list[40];
	this.TabSequence=list[41];
	this.Tooltip=list[42];
	this.ValueGet=list[43];
	this.ValueSet=list[44];
	
	this.Align="";
	this.Width="";
	var style=this.Style
	if (style!=="")
	{
		var style=style.split(",");
		if (typeof(style[0])=="undefined") style[0]=""
		if (typeof(style[1])=="undefined") style[1]=""
		if (style[1]=="center" || style[1]=="left" || style[1]=="right")
		{
			this.Align=style[0];
		}
		else
		{
			if (isNumber(style[0])) this.Width=style[0];
		}
		if (style[1]=="center" || style[1]=="left" || style[1]=="right") this.Align=style[0];
		if  (isNumber(style[1]))this.Width=style[1];
	}
}

///add by zy 2017-4-6  ZY0162
///创建列字段对象
///入参：itemID  	DHC_EQCComponentItem表的ID
///		 itemSetID  DHC_EQCComponentSetItem表的ID
///DataGrid的columns是个josn对象 ：{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true}
///根据取到的元素信息，最终生成一个josn
function setColData(itemID,itemSetID)
{
	if (itemID=="") return "";
	var objItem=new ComponentItem(itemID,itemSetID)
    this.field = objItem.Name;
    this.title = objItem.Caption;
    if (objItem.Width!="") this.width = objItem.Width;
    if (objItem.Align!="") this.align = objItem.Align;
    this.hidden = objItem.Hidden;
    if (objItem.DisplayOnly=="N") this.editor = texteditor;
    //text 不需要formatter属性;
    if (objItem.DisplayType=="0") return
	this.formatter =  function(value,row,index)
	{
		if (row.TRowID=="") return
		var html=""
		if (objItem.DisplayType=="1" )
		{
			var str=objItem.LinkExpression
			//var str="'&RowID='_rs.GetDataByName('msgID')_'&ReadOnly='_%Request.Get('ReadOnly')_'&vData='_%Request.Get('vData')_'&actionDesc='_rs.GetListDataByName('actionDesc')_'&actionCode='_rs.GetListDataByName('actionCode')_'&roles='_rs.GetListDataByName('roles')"
			if(typeof(str)=="undefined" || str=="") return;
			str=str.replace(/'/g,"")	//去掉单引号
			str=str.replace(/_/g,"")	//去掉空下划线
			str=str.replace(/%Request.Get/g,"%")	//去掉空下划线
			str=str.replace(/rs.GetDataByName/g,"#")	//去掉空下划线
			str=str.replace(/rs.GetListDataByName/g,"@")	//去掉空下划线
			var arg=str.split("&")
			var para=""
			var paralist=""
			var initLen=0
			for (var i=1;i<arg.length;i++)
			{
				var oneArg=arg[i].split("=");
				var oneArgName=oneArg[0];
				var oneArgType=oneArg[1].substring(0,1);
				var oneArgValueDesc=oneArg[1].substring(2,oneArg[1].length-1);
				if (oneArgType=="%")
				{
					para=para+"&"+oneArgName+"="+getJQValue($("#"+oneArgValueDesc))
				}
				else if (oneArgType=="#")
				{
					$.each(row,function(key,val)
					{
						if (oneArgValueDesc==key) para=para+"&"+oneArgName+"="+val
					})
				}
				else if (oneArgType=="@")
				{
					$.each(row,function(key,val)
					{
						if (oneArgValueDesc==key)
						{
							//val='18,19,'
							var list=val.split(",")
							if (initLen==0) initLen=list.length-1
							paralist=paralist+"&"+oneArgName+"="+val
						}
					})
				}
				else
				{
					para=para+"&"+arg[i]
				}
			}
			var url=objItem.LinkUrl
			if (url.indexOf('?')==-1) url=url+"?"
			url=url+para
			if (paralist!="")
			{
				for (var i=1;i<=initLen;i++)
				{
					var oneurl=url
					var name="审核"
					var list=paralist.split("&")
					for (var j=1;j<list.length;j++)
					{
						var oneArg=list[j].split("=")
						oneArgName=oneArg[0]
						oneArgValue=oneArg[1].split(",")
						if (oneArgName=="actionDesc")
						{
							if (oneArgValue[i]!="") name=oneArgValue[i]
						}
						oneurl=oneurl+"&"+oneArgName+"="+oneArgValue[i]
					}
	   			 	html=html+'<A onclick="OpenNewWindow(&quot;'+oneurl+'&quot;)" href="#" style="margin-left:5px">'+name+'</A>';
					//html='<A onclick="OpenNewWindow(&quot;'+url+'&quot;,&quot;'+objItem.ShowInNewWindow+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/'+objItem.Image+'" /></A>';
				}
			}
			else
			{
				html='<A onclick="OpenNewWindow(&quot;'+url+'&quot;,&quot;'+objItem.ShowInNewWindow+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/'+objItem.Image+'" /></A>';
			}
			
		}
		else if (objItem.DisplayType=="2" )
		{
			if (objItem.LookupJavascriptFunction=="") return
			html='<button type="button" onclick="'+objItem.LookupJavascriptFunction+'()">'+this.title+'</button>';
			//messageShow("","","",html)
		}
		else if (objItem.DisplayType=="3" )
		{
			if (objItem.LookupJavascriptFunction=="") return
			html=checkBox(value,objItem.LookupJavascriptFunction,this.field,index)
			//messageShow("","","",value+"&"+objItem.LookupJavascriptFunction+"&"+this.field+"&"+index)
			/*
			html='<input type="checkbox" name="DataGridCheckbox" onclick="'+objItem.LookupJavascriptFunction+'(&quot;'+this.field+'&quot;,&quot;'+index+'&quot;)"';
			if(value=="Y"){html=html+' checked="checked" value="N" >';}
			else{html=html+' value="Y" >';}
			*/
			//messageShow("","","",html)
		}
		return html;
	}
}

///add by zy 2015-11-26   ZY0162
///根据table的名称来取对应table可以显示的数据列信息,动态生成一个columns对象
///入参：
///		componentName:  组件名称
///		groupID	: 安全组ID
///		userID	：用户ID
///		hospID	：hospID院区ID
///返回值:josn  
///返回值示例：[[
///		{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
///		{field:'TCode',title:'代码',width:100,align:'center'},
///	]]
function GetCurColumnsInfo(componentName,groupID,userID,hospID)
{
    var columns = new Array();
    var cols = new Array();
    $.ajax({
	    	async: false,
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCComponentSet",
                MethodName:"GetComponentItemSetInfo",
		        	Arg1:componentName,
					Arg2:groupID,
					Arg3:userID,
					Arg4:hospID,
			        ArgCnt:4
            },
            success:function (data, response, status) {
				data=data.replace(/\ +/g,"")	//去掉空格
				data=data.replace(/[\r\n]/g,"")	//去掉回车换行
				if (data=="")return;
				var list=data.split("^");
				var Len=list.length;
				for (var i=0;i<Len;i++)
				{
					var colItem=list[i];
					var colItem=colItem.split(",");
					var newColData=new setColData(colItem[0],colItem[1])
					cols.push(newColData)
				}
				columns.push(cols)
            }
    });
    return columns
}

var EVENCOLOR="#DFFFDF";
var oldIndex=-1;
var oldBackColor="";
function SelectRowColor(grid,row,preIndex)
{
	var index=grid.datagrid('getRowIndex',row);
	//if (preIndex==index) return;				//modified by czf 562047 begin
	//oldIndex=index;
	var panel =grid.datagrid('getPanel');   
    var tr = panel.find('div.datagrid-body tr');
    var bakcss="";
    tr.each(function(){
	    var tempIndex = parseInt($(this).attr("datagrid-row-index"));
	    if ((tempIndex%2)==1)   //偶数行
	    {
			if (oldIndex!=index){						//点击行
		        if (tempIndex == index)	//设置选中行背景颜色
		        {
			        oldBackColor=($(this).css("background-color"));
			        $(this).css({   
			            "background": "#0092DC",
			            "color": "#fff"  
			        });
					oldIndex=index;	
		        }
		        if (tempIndex == preIndex)	//恢复原来选中行颜色
		        {
			        $(this).css("background-color",oldBackColor);
			        $(this).css("color","#000000");
			    }
			}
			else		//点击选中行
		    {
			    if (tempIndex==index){
				    $(this).css({   
			            "background": EVENCOLOR,
			            "color": "#000000"  
			        });
		        	oldIndex=-1;
		        }
			}
	    }		
     });							//modified by czf 562047 end
     oldcss=bakcss;
}
function GetJQueryDate(vElementID)
{
	var DateText=jQuery(vElementID).datebox('getText');
	var DateValue=jQuery(vElementID).datebox('getValue');
	if ((DateText=="")&&(DateValue!="")) return ""
	return DateValue
}
//设置默认焦点
function setFocus(id)
{
	if(jQuery("#" + id).length)
	{
		jQuery("#" + id).focus();
	}
}

///Add By ZX 2017-03-08
///描述:改变日期控件格式为YYYY-MM
jQuery.extend({
    MonthBox: function(Obj) {
    Obj.datebox({    
        onShowPanel : function() {// 显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层    
            span.trigger('click'); // 触发click事件弹出月份层    
            if (!tds)    
                setTimeout(function() {// 延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔    
                    tds = p.find('div.calendar-menu-month-inner td');    
                    tds.click(function(e) {    
                        e.stopPropagation(); // 禁止冒泡执行easyui给月份绑定的事件    
                        var year = /\d{4}/.exec(span.html())[0]// 得到年份   
                        , month = parseInt(jQuery(this).attr('abbr'), 10) ; // 月份 
                        Obj.datebox('hidePanel') // 隐藏日期对象    
                        .datebox('setValue', year + '-' +  month); // 设置日期的值    
                    });
                }, 0);
        },
        parser : function(s) {// 配置parser，返回选择的日期
            if (!s)
                return new Date(); 
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);    
        },    
        formatter : function(d) { 
            var month = d.getMonth()+1;
            if(month<10){
                month = "0"+month;
            }     
            return d.getFullYear() + '-' + month;    
            
        }// 配置formatter，只返回年月    
    });
    var p = Obj.datebox('panel'), // 日期选择对象    
    tds = false, // 日期选择对象中月份    
    span = p.find('span.calendar-text'); // 显示月份层的触发控件  
    }
});

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
///add by 曾超  2016-05-30
function getParam(paramName)
{
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1)
    {
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound)
        {
            if (arrSource[i].indexOf("=") > 0)
            {
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase())
                 {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        }   
    }
   return paramValue;
}

///add by zy 2017-02-15 ZY0162
///处理使用了easyui的class之后元素取值不兼容问题。
///入参：
///		obj:  jQuery对象  例如：$("#Remark")
///		type: "value"和"text"
///返回值:对象的值  
function getJQValue(obj,type)
{
	var value=""
	//var className=obj.attr('class');
	if (obj.hasClass('easyui-textbox'))
	{
		value=obj.textbox('getValue');
	}
	else if ((obj.hasClass('easyui-combobox'))||(obj.hasClass('combobox-f')))
	{
		if (type=='value') value=obj.combobox('getValue');
		if (type=='text') value=obj.combobox('getText')
	}
	else if (obj.hasClass('combogrid-f'))
	{
		if (type=='value') value=obj.combogrid('getValue');
		if (type=='text') value=obj.combogrid('getText')
	}
	else if (obj.hasClass('easyui-datebox'))
	{
		value=obj.datebox('getValue');
	}
	else
	{
		if (obj.attr('type')=='checkbox')
		{
			value=(obj.is(':checked')==true)?'Y':'N'
		}
		else if ((obj.attr('type')=='hidden')||(obj.attr('type')=='text'))
		{
			value=obj.val();
		}
		else
		{
			value=obj.val();
		}
	}
	if(typeof(value)=="undefined") value="";
	return value
}

///add by zy 2017-02-15 ZY0162
///处理使用了easyui的class之后元素赋值不兼容问题。
///入参：
///		obj:  jQuery对象  例如：$("#Remark")
///		value: 对象需要设置的值
///		type: "value"和"text"
function setJQValue(obj,value,type)
{
	if(typeof(value)=="undefined") value="";
	//var className=obj.attr('class');
	if (obj.hasClass('easyui-textbox'))
	{
		obj.textbox('setValue',value);
	}
	else if ((obj.hasClass('easyui-combobox'))||(obj.hasClass('combobox-f')))
	{
		obj.combobox('setValue',value);
		//if (type=='value') obj.combobox('setValue',value);
		//if (type=='text') obj.combobox('setText',value)
	}
	else if (obj.hasClass('combogrid-f'))
	{
		if (type=='value') obj.combogrid('setValue',value);
		if (type=='text') obj.combogrid('setText',value)
	}
	else if (obj.hasClass('easyui-datebox'))
	{
		obj.datebox('setValue',value);
	}
	else
	{
		if (obj.attr('type')=='checkbox')
		{
			if ((value==true)||(value=='Y')||(value==1))
			{
				value='ture';
			}
			else
			{
				value=false;
			}
			obj.prop("checked",value);
		}
		else if ((obj.attr('type')=='hidden')||(obj.attr('type')=='text'))
		{
			obj.val(value);
		}
		else
		{
			obj.val(value);
		}
	}
	/*
	switch (className)
	{
		//easyui-textbox
		case 'easyui-textbox textbox-f':
			obj.textbox('setValue',value);
		  	break;
		//easyui-combogrid
		case 'text combogrid-f combo-f textbox-f':
			if (type==0) obj.combogrid('setValue',value);
			if (type==1) obj.combogrid('setText',value)
		  	break;
		//easyui-datebox
		case 'easyui-datebox datebox-f combo-f textbox-f':
			obj.datebox('setValue',value);
		  	break;
		//undefined
		default:
			if (obj.attr('type')=='checkbox')
			{
				obj.prop("checked",value);
			}
			else if (obj.attr('type')=='hidden')
			{
				obj.val(value);
			}
		  	break;
	}*/
}
///add by zy 2017-02-15 ZY0162
///处理使用了easyui的class之后元素不可用不兼容问题。
///入参：
///		obj:  jQuery对象  例如：$("#Remark")
///		value: true  false
function disableJQObj(obj,value)
{
	//var className=obj.attr('class');
	//messageShow("","","",obj.attr('class'))
	if (obj.hasClass('easyui-textbox'))
	{
		obj.textbox({disabled: value});
	}
	else if ((obj.hasClass('easyui-combobox'))||(obj.hasClass('combobox-f')))
	{
		 obj.combobox({disabled: value});
	}
	else if (obj.hasClass('combogrid-f'))
	{
		 obj.combogrid({disabled: value});
	}
	else if (obj.hasClass('easyui-datebox'))
	{
		obj.datebox({disabled: value});
	}
	else
	{
		if (obj.attr('type')=='checkbox')
		{
			//obj.prop("checked",value);
			obj.attr("disabled",value);
		}
		else if ((obj.attr('type')=='hidden')||(obj.attr('type')=='text'))
		{
			obj.attr("disabled",value);
		}
	}
}
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}


function isNumber(value) {
    var patrn = /^[0-9]*$/;
    if (patrn.exec(value) == null || value == "") {
        return false
    } else {
        return true
    }
}

///add by zy 2017-08-07 ZY0162
///easyUI formatter  checkbox 格式化
///入参：
///		value	：判断Y/N
///		functionName	:处理逻辑函数
///		para	：事件的参数
///		index	：行索引
///返回 html代码
function checkBox(value,functionName,para,index)
{
	html='<input type="checkbox" name="DataGridCheckbox" onclick="'+functionName+'(&quot;'+para+'&quot;,&quot;'+index+'&quot;)"';
	if(value=="Y"){html=html+' checked="checked" value="N" >';}
	else{html=html+' value="Y" >';}	
	return html
}
///add by jyp 2018-03-23 566030
///ajax方法error解析
///入参：
///		XMLHttpRequest	
///		textStatus	
///		errorThrown	
function ErrorMessages(XMLHttpRequest,textStatus,errorThrown)
{
	if(XMLHttpRequest.status>-1)
	{
		jQuery.messager.show({title: '提示',msg:'保存失败！请检查网络是否通畅！'});	
	}
}


///add by jyp 2018-06-15  JYP0013
function GetFileName()
{
	try 
	{
		var xls = new ActiveXObject("Excel.Application");   
		var fName = xls.GetSaveAsFilename("","Excel File(*.xls),*.xls")
		if (fName==false)
		{
		 fName=""
		}
		return fName
	}
	catch(e)
	{
		/*
		alertShow("name: " + e.name + 
		"description:"+e.description+
    "message: " + e.message + 
    "lineNumber: " + e.lineNumber + 
    "fileName: " + e.fileName + 
    "stack: " + e.stack);
    */
		messageShow("","","",e.message);
		return "";
	}
}
///add by jyp 2018-06-15  JYP0013
function ColFormat(val,format)
{
	//"1:YYYY-MM-DD"
	//"11:YYYY年MM月DD日"
	//"12:dd/mm/yyyy"
	//"2:0.00"
	//"3:短名称根据-截取
	//"4:文本格式?主要处理如设备编号等科学记数法显示的问题?
	if (format=="1")
	{
		return FormatDate(val,"","");
	}
	else if (format=="2")
	{
		val=val*100;
		val=Math.round(val,2);
		val=val/100;
		val=val.toFixed(2);
		return val;
	}
	else if (format=="3")
	{
		val=GetShortName(val,"-");
		return val;
	}
	else
	{
		return val
	}
	
}