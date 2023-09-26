var t=new Array();
///Add By DJ 2018-07-06
///描述:HISUI页面除入参元素之外的所有Lookup元素初始化
///入参:vExcludesids 初始化除外元素 格式"元素名1,元素名2,....元素名n"
///返回值:无
tabflag=0   //add by lmm 2020-06-29 回车下一输入框全局变量
function initLookUp(vExcludesids)
{
	var lookupid={};
	var lookupparas={};
	var lookupjsfun={};
	//根据样式遍历可改写元素
	$(".hisui-validatebox").each(function(){
		var id=$(this)[0].id;
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			//取元素的信息
			var options=jQuery("#"+id).attr("data-options");
			if ((options!=undefined)&&(options!=""))
			{
				//转json格式
				options='{'+options+'}';
				var options=eval('('+options+')');
				var componentName=options.component;
				if ((componentName!=undefined)&&(componentName!=""))
				{
					//modify by lmm 2020-02-28 增加下拉框自动检索最小字数
					var vminQueryLen="0"
					//modify by lmm 2020-06-17 增加放大镜弹窗尺寸
					singlelookup(id,componentName,options.paras,options.jsfunction,vminQueryLen,options.defaultsize)
				}
			}
		}
	});
}
///Add By DJ 2018-07-30
///描述:HISUI单个Lookup元素初始化
///入参:vElementID lookup元素名
///		vComponentName	lookup元素列信息定义名称
///		vQueryParams lookup元素调用查询入参. 按优先级高低分为三种情况(1)JS传递(2)data-options属性设置(3)未设置取列信息定义配置
///					data-options属性设置格式:"paras:json格式参数数组"
///					参数格式:[{name:入参名1,type:参数类型,value:参数值},{name:入参名2,type:参数值类型,value:参数值}....]
///					参数值类型分为:1 表示lookup输入框元素,2 表示固定值,3  session名称,4 指定元素名
///		vfunction lookup元素选择记录回调函数.按优先级高低分为三种情况(1)JS传递(2)data-options属性设置(3)未设置固定调用函数setSelectValue
///					data-options属性设置格式:"jsfunction:回调函数名"
///返回值:无
///增加入参 vminQueryLen：下拉框自动检索最小字数 modify by lmm 2020-02-28 LMM0060
///modify by lmm 2020-06-17 vDefaultSize：增加放大镜弹窗尺寸
function singlelookup(vElementID,vComponentName,vQueryParams,vfunction,vminQueryLen,vDefaultSize)
{
	if (vComponentName!="")
	{
		var lookupinfo=tkMakeServerCall("web.DHCEQ.Plat.CTCComponentSet","GetComponentsInfo",vComponentName)
		var lookupObj=JSON.parse(lookupinfo)
		var componentInfo=lookupObj[vComponentName]
		if (componentInfo!="")
		{
			var options=jQuery("#"+vElementID).attr("data-options");
			var optionflag=0
			if ((options!=undefined)&&(options!=""))
			{
				//转json格式
				optionflag=1
				options='{'+options+'}';
				var options=eval('('+options+')');
			}
			if (((vQueryParams=="")||(vQueryParams==undefined))&&(optionflag==1)){vQueryParams=options.paras}
			if (((vfunction=="")||(vfunction==undefined))&&(optionflag==1)){vfunction=options.jsfunction}
			if (((vDefaultSize=="")||(vDefaultSize==undefined))&&(optionflag==1)){vDefaultSize=options.defaultsize}
			lookupHander(new component(componentInfo,vDefaultSize),vElementID,vQueryParams,vfunction,vminQueryLen);
		}
	}
}
///Add By DJ 2018-07-30
///描述:根据列信息定义字符串生成列对象
///入参:列信息定义字符串.格式:"列信息定义RowID^列信息定义名^列信息定义标题^调用类名^调用查询名^调用查询入参^lookup元素DR列名^lookup元素显示列名^回调函数"
///		调用查询入参格式:"参数1#参数2#......参数n"		参数格式:"入参名*入参位置*入参值类型*入参值"
///返回值:无
//modify by lmm 2020-06-17 LookupSize：增加放大镜弹窗尺寸
function component(str,LookupSize)
{
	var str=str.split("^");
	this.id=str[0];
	this.name=str[1];
	this.caption=str[2];
	this.className=str[3];
	this.queryName=str[4];
	this.params=str[5];
	this.idField=str[6];
	this.textField=str[7];
	//modified by ZY0197 2019-11-27  
	//this.callBackFunction=str[8];
	this.width=400;
	this.height=200;
	if (str[8]!="")
	{
		var defaultSize=str[8]
	}
	if((LookupSize!="")&&(LookupSize!=undefined))
	{
		var defaultSize=LookupSize
	}
	if ((defaultSize!="")&&(defaultSize!=undefined))
	{
		var defaultSize=defaultSize.split(",");
		for (var i=0;i<defaultSize.length;i++)   
		{
			var oneCaption=defaultSize[i].split(":");
			if (oneCaption[0]=="width") this.width=oneCaption[1];
			else if (oneCaption[0]=="height") this.height=oneCaption[1];
		}
	}
	this.columns=getCurColumnsInfo(this.name,"","","");
}
///Add By DJ 2018-07-06
///描述:HISUI功能页面放大镜元素Lookup定义及change清空对应dr元素值事件绑定
///入参:component 列信息定义对象
///		vElementID lookup元素名
///		vQueryParams lookup元素调用查询入参. 分为三种情况(1)JS传递(2)data-options属性设置(3)未设置取列信息定义配置
///					data-options属性设置格式:"paras:json格式参数数组"
///					参数格式:[{name:入参名1,type:参数类型,value:参数值},{name:入参名2,type:参数值类型,value:参数值}....]
///					参数值类型分为:1 表示lookup输入框元素,2 表示固定值,3  session名称,4 指定元素名
///		vfunction lookup元素选择记录回调函数.分为三种情况(1)JS传递(2)data-options属性设置(3)未设置固定调用函数setSelectValue
///					data-options属性设置格式:"jsfunction:回调函数名"
///返回值:无
///增加入参 vminQueryLen：下拉框自动检索最小字数 modify by lmm 2020-02-28 LMM0060
function lookupHander(component,vElementID,vQueryParams,vfunction,vminQueryLen)
{
	if ((vminQueryLen=="")||(vminQueryLen==undefined))
	{
		
		var vminQueryLen="0"
	}
    if (component=="") return
    $('#'+vElementID).lookup({
		//modified by ZY0197 2019-11-27
		panelWidth:component.width,
		panelHeight:component.height,
		mode: 'remote',
		pagination:true,
		lazy:true,
		showPageList:false,
		showRefresh:false,
		minQueryLen:vminQueryLen,   //modify by lmm 2020-02-24
		isCombo:true,
	    onBeforeLoad:function(param){
			//JS文件传递参数或dataoption属性定义参数
			if ((vQueryParams!="")&&(vQueryParams!=undefined))
			{
				for (var i=0;i<vQueryParams.length;i++)
				{
				    //获取combogrid输入框值
				    if(vQueryParams[i].type=="1") {param[vQueryParams[i].name]=$('#'+vQueryParams[i].value).lookup("getText");}
					//获取默认值  常量
					else if(vQueryParams[i].type=="2"){param[vQueryParams[i].name]=vQueryParams[i].value;}
					//获取session值
					else if(vQueryParams[i].type=="3"){param[vQueryParams[i].name]=session[vQueryParams[i].value];}
					//通过js写getParam参数取值
					else if(vQueryParams[i].type=="5"){param[vQueryParams[i].name]=getParam(vQueryParams[i].value);}
					//获取CheckBox值	 MZY0030	1340074		2020-06-01
					else if(vQueryParams[i].type=="6"){param[vQueryParams[i].name]=document.getElementById(vQueryParams[i].value).checked;}
					//获取界面其他元素值
					else{param[vQueryParams[i].name]=getElementValue(vQueryParams[i].value);}
				}
			}
			else
			{
				var option=component.params.split("#");
			    for (var i=0;i<option.length;i++)
			    {
				    var oneParaInfo=option[i].split("*");
				    //获取combogrid输入框值
				    if(oneParaInfo[2]=="1") {param[oneParaInfo[0]]=$('#'+vElementID).lookup("getText");}
					//获取默认值  常量
					else if(oneParaInfo[2]=="2"){param[oneParaInfo[0]]=oneParaInfo[3];}
					//获取session值
					else if(oneParaInfo[2]=="3"){param[oneParaInfo[0]]=session[oneParaInfo[3]];}
					//通过js写getParam参数取值
					else if(oneParaInfo[2]=="5"){param[oneParaInfo[0]]=getParam(oneParaInfo[0]);}
					//获取界面其他元素值
					else{param[oneParaInfo[0]]=getElementValue(oneParaInfo[3]);}
				}
			}
			return true;
			},
		queryParams:{ClassName: component.className,QueryName: component.queryName},
		url: $URL,
		idField: component.idField,
		textField: component.textField,
		onSelect:function (ind,item){
			if ((vfunction)&&(vfunction!=undefined)&&(vfunction!=""))
			{
				//JS文件传递回调函数或dataoption属性定义回调函数
				vfunction(item);
			}
			else
			{
				setSelectValue(vElementID,item);

			}
				lookuptab(vElementID)   //add by lmm 2020-06-29 回车下一输入框
				tabflag=1
			},
		columns:component.columns
	});
	$('#'+vElementID).bind("input propertychange change",function(event){clearData(vElementID)})
}

///Add By DJ 2018-07-30
///描述:根据lookup元素列信息定义名动态生成对应展示columns对象
///入参：
///		componentName:  lookup元素列信息定义名
///		groupID	: 安全组ID
///		userID	：用户ID
///		hospID	：hospID院区ID
///     frozen	: 冻结列标识   /// Modefiedy by ZC0041 2018-10-29
///返回值:lookup元素列信息定义对应展示列对象.  格式：[[列1,列2....,列n]]
///		列格式:{field:查询输出列,title:前台显示列名,width:列宽,align:显示位置,hidden:是否隐藏}
function getCurColumnsInfo(componentName,groupID,userID,hospID,frozen)
{
	if(frozen==null) frozen=""
    var columns = new Array();
    var cols = new Array();
    var resultData=$.cm({
		ClassName:"web.DHCEQ.Plat.CTCComponentSet",
		QueryName:"ComponentSetItem",
		ComponentName:componentName,
		GroupID:groupID,
		UserID:userID,
		HosptailID:hospID,
		Frozen:frozen,     /// Modefiedy by ZC0041 2018-10-29 添加冻结列标识
		},false)
    	///modified by zy 20180930  ZY0170  增加同一Sort输出的操作列处理
	var preSort=-1;
	var newColData;	
	var multipCol = new Array();
	for (var i=0;i<resultData.rows.length;i++)
	{
		var colData=resultData.rows[i];
		var curSort=colData.TSort;
		var insertFlag=""						//add by wl 2019-10-25
		if ((curSort==preSort)&&(curSort!=0))  //modify by lmm 2018-12-13
		{
			//newColData.title="操作"
			multipCol.push(colData);
			insertFlag=1					   //add by wl 2019-10-25
		}
		else
		{
			preSort=curSort;
		}
		var nextsort=""
		if (i<resultData.rows.length)
		{
			if (resultData.rows[i+1]) nextsort=resultData.rows[i+1].TSort
		}
		if ((nextsort!=curSort)||(nextsort==0))  //modify by lmm 2018-12-13
		{
			if (multipCol.length==0) multipCol.push(colData);
			newColData=new setColData(colData,multipCol);
			cols.push(newColData);
			multipCol=[]
		}
		else
		{
			
			if (insertFlag=="") multipCol.push(colData);   //modify by wl 2019-10-25
		}
	}
	columns.push(cols);
	return columns;
}
///Add By DJ 2018-07-30
///描述:根据列信息定义字段内容创建列字段对象
///入参:oneItem 列信息定义对象
///返回值:无
///modify by jyp 2018-10-19  JYP0015 调整取列Style的循环取值。
function setColData(oneItem,multipCol)
{
	if (oneItem=="") return "";
    this.field = oneItem.TName;
    this.title = oneItem.TCaption;
    this.description=oneItem.TDescription;
    //Modify By zx 2020-02-20 BUG ZX0076 列排序
    this.sortable=oneItem.TOrderMode;
    //modified by ZY0199 2019-12-11  
    //0:string,1:int,2:float,3:date,4:time,5:bool
    if ((oneItem.TDataType=="1")||(oneItem.TDataType=="2"))this.align ="right" ;
	if (oneItem.THidden=="Y")this.hidden =true ;
	else this.hidden=false
	///modified by zy 20191202 ZY0197
	///整理DataType和DisplayType  两个字段的内容.
	///DataType用于记录元素的字段类型
	///DisplayTyp用于控制元素显示的内容和编辑状态下的类容
	///setEditorStyle 这个函数删除.
	/*
	///modified by zy 20180930  ZY0170  TDisplayOnly N:可编辑,设置editor属性;Y: 不可编辑
    if (oneItem.TDisplayOnly=="N")
    {
	    this.editor=setEditorStyle(oneItem)
	}
	*/
	//modified BY ZY0201  放在前面 formatter 里面有可能会赋值width
    var style=oneItem.TStyle
	if (style!=="")
	{
		var style=style.split(",");
		for (var i=0;i<style.length;i++)
		{
			var onestyle=style[i].split(":");
			if (onestyle[0]=="width") this.width=parseFloat(onestyle[1]);
			else if (onestyle[0]=="align") this.align=onestyle[1];
		}
	}
	//text 不需要formatter属性;
	//0:text,1:link,2:button,3:checkbox,4:icheckbox,5:switchbox,6:numberbox,7:combobox,
	//8:validatebox,9:combogrid,10:datebox,11:datetimebox,12:combotree,13:textare
	switch (oneItem.TDisplayType)
	{
		case '0':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'text',options:{}}
		    //维护预警界面增加一个图标显示.
		    if (oneItem.TImage=="") return
		    this.formatter =  function(value,row,index){
				    var curImage=oneItem.TImage
				    if (curImage.indexOf(".")<=0)
				    {
					    curImage=getAutoPic(row)
				    }
				    else
				    {
					    curImage="../scripts_lib/hisui-0.1.0/dist/css/icons/"+curImage
				    }
				    if (curImage=="") return ""
				    var html=""
				    html='<img border=0 complete="complete" src="'+curImage+'" />'+value;
				    return html
			    }
		break;
		case '1':
		    this.formatter =  function(value,row,index){
					var html=""
					var len=multipCol.length
					for (var i=0;i<len;i++)
					{
						var onehtml=oneFormatterHtml(value,row,index,multipCol[i])
						if (html=="")
						{
							html=onehtml
						}
						else
						{
							html=html+'&nbsp;&nbsp;'+onehtml
						}
					}
					return html;
				}
		break;
		case '2':
		    this.formatter =  function(value,row,index){
					var html=""
					if (oneItem.TLookupJavascriptFunction=="") return
					if (oneItem.TDescription!="")
					{
						//add by zx 2018-11-09 按钮改为hisui样式
						html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.description+'</a>'
						//html='<button id="'+oneItem.TName+'z'+index+'" type="button" onclick="'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.description+'</button>';
					}
					else
					{
						//add by zx 2018-11-09 按钮改为hisui样式
						html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.title+'</a>'
						//html='<button id="'+oneItem.TName+'z'+index+'" type="button" onclick="'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.title+'</button>';
					}
					return html;
				}
		break;
		case '3':
		//modify by lmm 2020-03-06 begin LMM0062
		    if (oneItem.TDisplayOnly!="Y") 
		    {
			    
			    this.editor={type: 'checkbox',options:{on:'Y',off:'N'}}
			    var disable=""
		    }
		    else
		    {
			    var disable="disabled"
			}
		    this.formatter =  function(value,row,index){
					var html=""
					//if (oneItem.TLookupJavascriptFunction=="") return			Mozy0242	2020-01-02	1143943
					html=checkBox(value,oneItem.TLookupJavascriptFunction,this.field,index,disable)
					return html;
		//modify by lmm 2020-03-06 begin LMM0062
				}
		break;
		case '4':
		    if (oneItem.TDisplayOnly!="Y") {this.editor={type: 'icheckbox',options:{on:'Y',off:'N'}}}
		    //modified by LMM 2020-04-16 去除勾选框取消编辑为数值状态
		    this.checkbox=true
		break;
		case '5':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'switchbox',options:{on:'Y',off:'N'}}
		break;
		case '6':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'numberbox',options:{precision:2}}
		break;
		case '7':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'combobox',options:{}}
		break;
		case '8':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'validatebox',options:{}}
		break;
		case '9':
		    if (oneItem.TDisplayOnly!="Y")
		    {
				///modified by zy0172  hisui改造  修改类文件的位置
				var lookupinfo=tkMakeServerCall("web.DHCEQ.Plat.CTCComponentSet","GetComponentsInfo",oneItem.TLookupCustomComponent)
				var lookupObj=JSON.parse(lookupinfo)
				var componentInfo=lookupObj[oneItem.TLookupCustomComponent]
				if (componentInfo!="")
				{
					var objcomponent =new component(componentInfo)
			    	this.editor={type: 'combogrid',options:{
										panelWidth:400,
										mode: 'remote',
										pagination:true,
										lazy:true,
										showPageList:false,
										showRefresh:false,
										minQueryLen:1,
										isCombo:true,
										queryParams:{ClassName: objcomponent.className,QueryName: objcomponent.queryName},
										url: $URL,
										idField:objcomponent.idField,
										textField:objcomponent.textField,
										columns:objcomponent.columns,
									    onBeforeLoad:function(param){
											//列定了参数的
											if (oneItem.TLookupProperties!="") objcomponent.params=oneItem.TLookupProperties
											var option=objcomponent.params.split("#");
										    for (var i=0;i<option.length;i++)
										    {
											    var oneParaInfo=option[i].split("*");
											    //获取combogrid输入框值
											    if(oneParaInfo[2]=="1") {param[oneParaInfo[0]]=param.q;}
												//获取默认值  常量
												else if(oneParaInfo[2]=="2"){param[oneParaInfo[0]]=oneParaInfo[3];}
												//获取session值
												else if(oneParaInfo[2]=="3"){param[oneParaInfo[0]]=session[oneParaInfo[3]];}
												//通过js写getParam参数取值
												else if(oneParaInfo[2]=="5"){param[oneParaInfo[0]]=getParam(oneParaInfo[0]);}
												//获取界面其他元素值
												else{param[oneParaInfo[0]]=getElementValue(oneParaInfo[3]);}
											}
											return true;
										},
										onSelect:eval(oneItem.TLookupJavascriptFunction),
										//modified by ZY0213
										onChange:function (newValue, oldValue){
											if ((newValue=="")&&(oldValue!=""))
											{
												eval(oneItem.THold1)
											}
										}
									}
								}
				}
			}
		break;
		case '10':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'datebox',options:{}}
		break;
		case '11':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'datetimebox',options:{}}
		break;
		case '12':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'combotree',options:{}}
		break;
		case '13':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'textarea',options:{}}
		break;
		default:
		  	break;
	}
/*	//modified BY ZY0201  放在前面 formatter 里面有可能会赋值width
    var style=oneItem.TStyle
	if (style!=="")
	{
		var style=style.split(",");
		for (var i=0;i<style.length;i++)
		{
			var onestyle=style[i].split(":");
			if (onestyle[0]=="width") this.width=onestyle[1];
			else if (onestyle[0]=="align") this.align=onestyle[1];
		}
	}*/
}
///Add By DJ 2018-07-30
///描述:获取元素值
///入参:vElementID 元素名
///返回值:元素值
///说明:getValueById为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function getElementValue(vElementID)
{
	return getValueById(vElementID)
}

///Add By DJ 2018-07-30
///描述:元素赋值
///入参:vElementID 元素名
///返回值:元素对象
///说明:setValueById为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function setElement(vElementID,vValue)
{
	return setValueById(vElementID,vValue)


}
///add by lmm 2020-06-29
///描述：lookup回车下一输入框
function lookuptab(vElementID)
{		

	var inputs=$("input[class^=hisui-][disabled!=disabled],select[class^=hisui-][disabled!=disabled]")	
	for(var i = 0;i<inputs.length;i++)
	{ 
		if ((vElementID==inputs[i].id)&&(inputs[i].className.indexOf("lookup") != -1))
			{
				if(i==(inputs.length-1))
				{     
					 if ((inputs[0].className.indexOf("combobox-f") != -1)||(inputs[0].className.indexOf("datebox-f") != -1))
					 {
						$("#"+inputs[0].id).next('span').find('input').focus()
					}
					else
					{
						inputs[0].focus()
					}
				}
				else
				{
					 if ((inputs[i+1].className.indexOf("combobox-f") != -1)||(inputs[i+1].className.indexOf("datebox-f") != -1))
					 {
						$("#"+inputs[i+1].id).next('span').find('input').focus()
					}
					else
					{
						inputs[i+1].focus()
					}
				}
			}
	}

}

///Add By DJ 2018-07-06
///描述:根据元素串分别设置元素的必填项属性.
///入参:vElementIDs 需要所设置必填项的元素名串 格式:"元素名1^元素名2^.....^元素名n"
///返回值:无
///说明:setItemRequire为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function setRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],true)
	}
}
///Add By DJ 2018-07-06
///描述:根据Json值解析并对对应元素赋值
///入参:{元素名1:元素值1,元素名2:元素值2,...元素名n:元素值n}
///返回值:无
function setElementByJson(vJsonInfo)
{
	for (var key in vJsonInfo)
	{
		setElement(key,vJsonInfo[key])
	}
}
///Add By DJ 2018-07-30
///描述:设置元素不可用
///入参:vElementID 元素名
///		vValue true表示不可用, false表示可用
///返回值:无
///说明:disableById和enableById为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function disableElement(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			disableById(vElementID)
		}
		else
		{
			enableById(vElementID)
		}
	}
}

///Add By CZF0075 2020-02-25
///描述:根据元素串分别设置元素是否可用
///入参:vElementIDs 需要所设置是否可用的元素名串 格式:"元素名1^元素名2^.....^元素名n"
///		vValue true表示不可用, false表示可用
///返回值:无
function setDisableElements(vElementIDs,vValue)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		disableElement(ElementList[i],vValue)
	}
}

///Add By DJ 2018-07-30
///描述:设置页面除入参元素外的所有输入框元素不可用
///入参:vExcludesids 除外元素串 格式:"元素名1^元素名2^....^元素名n"
///返回值:无
function disableAllElements(vExcludesids)
{
	vExcludesids="^"+vExcludesids+"^"
	$(":input").each(function(){
		var id=$(this)[0].id;
		var obj=document.getElementById(id);
		if (obj)
		{
			var value=(vExcludesids.indexOf("^"+id+"^")<0)
			disableElement(id,value)
		}
	})
}
///Add By DJ 2018-07-06
///描述:根据审批设置,角色,动作获取编辑字段清单
///入参:ApproveSetDR 审批设置RowID
///		CurRole 角色RowID
///		ActionCode 动作代码
///返回值:无
function initEditFields(ApproveSetDR,CurRole,ActionCode)
{
	if (ActionCode==null) ActionCode=""
    var EditFieldsInfo=tkMakeServerCall("web.DHCEQ.Plat.BUSApprove","GetRequiredFields",ApproveSetDR,CurRole,ActionCode)
	var EditFieldsObj=JSON.parse(EditFieldsInfo)
	if (EditFieldsObj.SQLCODE<0){messageShow("","","",EditFieldsObj.Data);return;}
	if (EditFieldsObj.Data=="") return
	var List=EditFieldsObj.Data.split("^");
	var Len=List.length;
	for (var i=0;i<Len;i++)
	{
		var infor=List[i];
		var infor=infor.split(",");
		ObjEditFields[i]=new editFieldInfo(infor[0],infor[1],infor[2],infor[3],infor[4],infor[5],infor[6]);
	}
}

///Add By DJ  2018-07-06
///描述:生成编辑字段信息
///入参:RowID		DHCEQCRoleReqFields编辑字段表RowID
///		FieldName	DHCEQCRoleReqFields编辑字段元素名
///		TableName	DHCEQCRoleReqFields编辑字段对应表名
///		MustFlag	是否必填 Y表示必填 N表示非必填
///		ListFlag	是否列表元素 Y表示是 N表示否
///		FieldType	编辑字段类型. 1文本 2日期 3引用 4数值 5时间 6选择
///		RowIDName	列表元素对应行RowID名
///返回值:无
function editFieldInfo(RowID,FieldName,TableName,MustFlag,ListFlag,FieldType,RowIDName)
{
	this.RowID=RowID;
	this.FieldName=FieldName;
	this.TableName=TableName;
	this.MustFlag=MustFlag;
	this.ListFlag=ListFlag;
	this.FieldType=FieldType;	
	if (!RowIDName) RowIDName="";
	this.RowIDName=RowIDName;
	//引用型
	if (FieldType==3)
	{
		FieldName=getEditElementName(FieldName);
	}
	this.EditFieldName=FieldName;
	if (ListFlag=="Y")
	{
		this.FieldCaption=getColCaption(FieldName);
	}
	else
	{
		this.FieldCaption=getElementValue("c"+FieldName);
		var obj=document.getElementById("c"+FieldName);
		if (obj)
		{
			enableById(FieldName)
			if (MustFlag=="Y")
			{
				setRequiredElements(FieldName)
			}
		}
	}
}
///Add By DJ 2018-07-30
///描述:根据DR元素名获取对应编辑元素的Name,
///入参:DRName 
///HISUI改造:修改获取对应编辑元素的Name的规则 QW20181023
function getEditElementName(DRName)
{
	var editElement="";
	var level=0;
	$('[id^='+DRName+'_]').each(function(){
		var EditElementName=$(this)[0].id;
		var EditSplit=EditElementName.split("_")
		if (EditSplit[EditSplit.length-1].indexOf("Desc")>=0)
		{ 
			level=4;
			editElement=EditElementName
		}
		else if (EditSplit[EditSplit.length-1].indexOf("Name")>=0)
		{ 
			if (level<4)
			{
				level=3;
				editElement=EditElementName
			}
		}
		else if (EditSplit[EditSplit.length-1].indexOf("Code")>=0)
		{
			if (level<3)
			{
				level=2;
				editElement=EditElementName
			}
		}
		else
		{
			if (level<2)
			{
				level=1;
				editElement=EditElementName
			}
		}
	})
	if (editElement=="")
	{
		editElement=DRName
		if (DRName.substr(DRName.length-2,2)=="DR")
		{
			editElement=DRName.substr(0,DRName.length-2)
			if (("#"+editElement).length<=0)
			{
				var EditInfo=t[-9232]
				EditInfo=EditInfo.replace("[Name]",editElement);
				messageShow("","","",EditInfo)
			}
		}
	}
	return editElement
}

///Add By DJ 2018-07-06
///描述:根据列名元素名获取该元素的Caption---待确认
///入参:colName 列表元素名
///返回值:列表元素名对应的中文名
function getColCaption(colName)
{
	var ComponentID=getElementValue("GetComponentID");
    var CaptionInfo=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetColumnCaption",ComponentID,colName,"Y")	//modified by csj 20190807 添加获取组件列定义标题参数
    var CaptionObj=JSON.parse(CaptionInfo)
    if (CaptionObj.SQLCODE<0){messageShow("","","",CaptionObj.Data);return ""}
	return CaptionObj.Data;
}
///Add By DJ 2018-07-06
///描述:初始化功能页面的审批按钮.默认隐藏6个审批按钮,根据业务审批设置显示当前步骤可操作审批按钮。
///入参:无
///返回值:无
function initApproveButton()
{
	var ApproveSetDR=getElementValue("ApproveSetDR");
	for (var i=1;i<=6;i++)
	{
		hiddenObj("BApprove"+i,1);
	}
	var nextStep=getElementValue("NextFlowStep");
	var curRole=getElementValue("CurRole");
	var nextRole=getElementValue("NextRoleDR");
	var RoleStep=getElementValue("RoleStep");
	///当当前用户角色和下一步角色一致时方可操作
	///如果工作流设置中该步骤可以取消则取消按钮可用
	var CancelFlag=getElementValue("CancelFlag");
	if ((curRole==nextRole)&&(CancelFlag=="Y")&&(nextStep==RoleStep))
	{
		var obj=document.getElementById("BCancelSubmit");
		if (obj)
		{
			jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-back'});
			jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
			jQuery("#BCancelSubmit").linkbutton({text:'退回'}); //Modify By zx 2020-02-20 BUG ZX0076 文本统一处理
		}
		//处理拒绝原因及审批意见的只读性
		disableElement("RejectReason",false);		
	}
	else
	{
		hiddenObj("BCancelSubmit",1)
		//处理拒绝原因及审批意见的只读性
		disableElement("RejectReason",true);
	}
	//处理拒绝原因及审批意见的只读性
	disableElement("EditOpinion",true);
	
	if (ApproveSetDR=="") return;
	
	///设置审批按钮标题及是否可用
    var ApproveFlowInfo=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveSet","GetApproveFlow",ApproveSetDR)
    var ApproveFlowObj=JSON.parse(ApproveFlowInfo)
    if (ApproveFlowObj.SQLCODE<0){messageShow("","","",ApproveFlowObj.Data);return;}
	var List=ApproveFlowObj.Data.split("^")
	for (var i=1;i<=List.length;i++)
	{
		var FlowInfo=List[i-1];
		var FlowList=FlowInfo.split(",");
		if ((curRole==nextRole)&&(nextStep==FlowList[0])&&(nextStep==RoleStep))
		{
			var obj=document.getElementById("BApprove"+nextStep);
			if (obj) 
			{
				jQuery("#BApprove"+nextStep).linkbutton({iconCls: 'icon-w-stamp'});
				jQuery("#BApprove"+nextStep).on("click", BApprove_Clicked);
				disableElement("EditOpinion",false);
				hiddenObj("BApprove"+i,0);
			}
		}
		else
		{
			hiddenObj("BApprove"+i,1);
		}
		//Modify By zx 2020-02-20 BUG ZX0076 防止赋值后样式变化
		//setElement("BApprove"+i,FlowList[2])
		jQuery("#BApprove"+i).linkbutton({text:FlowList[2]});
	}
	return;
}

///Add By ZY 2019-10-18
///描述:初始化功能页面的审批按钮.默认一个按钮,审核。
///入参:无
///返回值:无
function initApproveButtonNew()
{
	var ApproveSetDR=getElementValue("ApproveSetDR");
	//2019-07-25
	for (var i=1;i<=6;i++)
	{
		hiddenObj("BApprove"+i,1);
	}
	var nextStep=getElementValue("NextFlowStep");
	var curRole=getElementValue("CurRole");
	var nextRole=getElementValue("NextRoleDR");
	var RoleStep=getElementValue("RoleStep");
	///当当前用户角色和下一步角色一致时方可操作
	///如果工作流设置中该步骤可以取消则取消按钮可用
	var CancelFlag=getElementValue("CancelFlag");
	if ((curRole==nextRole)&&(CancelFlag=="Y")&&(nextStep==RoleStep))
	{
		var obj=document.getElementById("BCancelSubmit");
		if (obj)
		{
			jQuery("#BCancelSubmit").linkbutton({text:"退回"});    //modify by lmm 2019-11-22 LMM0050
			jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-back'});
			jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
		}
		//处理拒绝原因及审批意见的只读性
		disableElement("RejectReason",false);		
	}
	else
	{
		hiddenObj("BCancelSubmit",1)
		//处理拒绝原因及审批意见的只读性
		disableElement("RejectReason",true);
	}
	//处理拒绝原因及审批意见的只读性
	disableElement("EditOpinion",true);
	
	if (ApproveSetDR=="") return;
	
	///设置审批按钮标题及是否可用
    var ApproveFlowInfo=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveSet","GetApproveFlow",ApproveSetDR)
    var ApproveFlowObj=JSON.parse(ApproveFlowInfo)
    if (ApproveFlowObj.SQLCODE<0){messageShow("","","",ApproveFlowObj.Data);return;}
	var List=ApproveFlowObj.Data.split("^")
	for (var i=1;i<=List.length;i++)
	{
		var FlowInfo=List[i-1];
		var FlowList=FlowInfo.split(",");
		if ((curRole==nextRole)&&(nextStep==FlowList[0])&&(nextStep==RoleStep))
		{
			//SetCElement("BApprove",FlowList[2]);
			//SetCElement("BApprove","审核");
			//var obj=document.getElementById("BApprove"+nextStep);
			//$("#BApprove1").linkbutton({text:FlowList[2]})
			$("#BApprove1").linkbutton({text:"通过"})
			var obj=document.getElementById("BApprove1");
			if (obj) 
			{
				//jQuery("#BApprove"+nextStep).linkbutton({iconCls: 'icon-w-stamp'});
				//jQuery("#BApprove"+nextStep).on("click", BApprove_Clicked);
				//hiddenObj("BApprove"+i,0);
				jQuery("#BApprove1").linkbutton({iconCls: 'icon-w-stamp'});
				jQuery("#BApprove1").on("click", BApprove_Clicked);
				disableElement("EditOpinion",false);
				setElement("EditOpinion","同意");
				hiddenObj("BApprove1",0);
			}
		}
		/*
		else
		{
			hiddenObj("BApprove"+i,1);
		}
		setElement("BApprove"+i,FlowList[2])
		*/
	}
	return;
}
///Add By DJ 2018-07-30
///描述:页面所有必填项元素检测
///入参:Strs:不为空时对Strs中的必填元素不做DR是否为空的验证
///返回值:false表示无必填项需要处理 true表示存在必填项需要处理
///说明:checkMustItemNull为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function checkMustItemNull(Strs)
{
	if(checkMustLookupDRNull(Strs)) return true;  //add by lmm 2018-10-22
	var validateStrings=validateRequired();
	if (validateStrings=="")	return false;
	var value=validateStrings.split("^");
	var FirstName=value[0];
	var CValue=getElementValue("c"+FirstName);
	messageShow("","","",CValue+t[-9201]);
	return true;
}

///Add By DJ 2018-07-06
///描述:自动生成故障现象----待确认
///入参:type 系统参数配置的故障现象录入方式0 放大镜选择模式，1 手工录入自动保存基础数据，2 两种模式均可
///		i 列表元素时指当前记录行号
///返回值:故障现象RowID
function getFaultCaseRowID(type,i)
{		
	var FaultCaseName="MRFaultCaseDR_FCDesc"
	var FaultCaseDRName="MRFaultCaseDR"
	if ((i)&&(i!=""))
	{
		FaultCaseName="T"+FaultCase+"z"+i;
		FaultCaseDRName="T"+FaultCaseDRName+"z"+i;
	}	
	
 	if (getElementValue(FaultCaseDRName)!="")
 	{
  		return getElementValue(FaultCaseDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type==""))  return "";
	 	var FaultCase=getElementValue(FaultCaseName);
	 	if (FaultCase=="") return "";
	 	var val=getPYCode(FaultCase)+"^"+FaultCase;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTFaultCase","UpdFaultCase",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-06
///描述:自动生成故障原因----待确认
///入参:type 系统参数配置的故障原因录入方式0 放大镜选择模式，1 手工录入自动保存基础数据，2 两种模式均可
///		i 列表元素时指当前记录行号
///返回值:故障原因RowID
function getFaultReasonRowID(type,i)
{
	var FaultReasonName="MRFaultReasonDR_FRDesc";
	var FaultReasonDRName="MRFaultReasonDR";
	if ((i)&&(i!=""))
	{
		FaultReasonName="T"+FaultReasonName+"z"+i;
		FaultReasonDRName="T"+FaultReasonDRName+"z"+i;
	}
 	if (getElementValue(FaultReasonDRName)!="")
 	{
  		return getElementValue(FaultReasonDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var FaultReason=getElementValue(FaultReasonName);
	 	if (FaultReason=="") return "";
	 	var val="^"+FaultReason;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTFaultReason","UpdFaultReason",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-06
///描述:自动生成解决方法----待确认
///入参:type 系统参数配置的解决方法录入方式0 放大镜选择模式，1 手工录入自动保存基础数据，2 两种模式均可
///		i 列表元素时指当前记录行号
///返回值:解决方法RowID
function getDealMethodRowID(type,i)
{
	var DealMethodName="MRDealMethodDR_DMDesc";
	var DealMethodDRName="MRDealMethodDR";
	if ((i)&&(i!=""))
	{
		DealMethodName="T"+DealMethodName+"z"+i;
		DealMethodDRName="T"+DealMethodDRName+"z"+i;
	}
	
 	if (getElementValue(DealMethodDRName)!="")
 	{
  		return getElementValue(DealMethodDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var DealMethod=getElementValue(DealMethodName);
	 	if (DealMethod=="") return "";
	 	var val="^"+DealMethod;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTDealMethod","UpdDealMethod",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-06
///描述:自动生成故障类型----待确认
///入参:type 系统参数配置的故障类型录入方式0 放大镜选择模式，1 手工录入自动保存基础数据，2 两种模式均可
///		i 列表元素时指当前记录行号
///返回值:故障类型RowID
function getFaultTypeRowID(type,i)
{
	var FaultTypeName="MRFaultTypeDR_FTDesc";
	var FaultTypeDRName="MRFaultTypeDR";
	if ((i)&&(i!=""))
	{
		FaultTypeName="T"+FaultTypeName+"z"+i;
		FaultTypeDRName="T"+FaultTypeDRName+"z"+i;
	}
	
 	if (getElementValue(FaultTypeDRName)!="")
 	{
  		return getElementValue(FaultTypeDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var FaultType=getElementValue(FaultTypeName);
	 	if (FaultType=="") return "";
	 	var val="^"+FaultType;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTFaultType","UpdFaultType",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-30
///描述:tab标签页选择
///入参:vtabsname 标签组名
///		vtab 隐藏标签名
///返回值:无
function selectTab(vtabsname,vtab)
{
	if ((vtabsname=="")||(vtab=="")) return
	var tabindex=$("#"+vtabsname).tabs("getTabIndex","#"+vtab)
	$("#"+vtabsname).tabs("select",tabindex)
}
///Add By DJ 2018-07-30
///描述:隐藏tab标签页
///入参:vtabsname 标签组名
///		vtab 隐藏标签名
///返回值:无
function hiddenTab(vtabsname,vtab)
{
	if ((vtabsname=="")||(vtab=="")) return
	var tabindex=$("#"+vtabsname).tabs("getTabIndex","#"+vtab)
	$("#"+vtabsname).tabs("close",tabindex)
}
///----待确认
///Add By DJ 2018-07-30
///描述:追加树形控件节点数据
///入参:vtree 树形控件元素名
///		vid	 追加数据节点ID
///		vtext 追加数据内容
///		vparent 追加数据的父节点ID
///返回值:追加节点对象
function appendTree(vtree,vid,vtext,vparent)
{
	var treedata=[{"id":vid,"text":vtext}]
	if (vparent!="")
	{
		var parentObj=$("#"+vtree).tree("find",vparent)
		if (parentObj)
		{
			var FindObj=$("#"+vtree).tree("find",vid)
			if (!FindObj)
			{
				$("#"+vtree).tree('append', {parent:parentObj.target,data:treedata});
			}
		}
	}
	else
	{
		var FindObj=$("#"+vtree).tree("find",vid)
		if (!FindObj)
		{
			$("#"+vtree).tree('append', {data:treedata});
		}
	}
	return $("#"+vtree).tree("find",vid)
}

///add by lmm 2018-08-20
///描述：hisui改造 按钮最短长度为四字，根据最长按钮调整所有按钮长度
///入参:vExcludesids 初始化除外元素 格式"元素名1,元素名2,....元素名n"
function initButtonWidth(vExcludesids)
{
	var maxWidth=116 
	//遍历按钮id存入数组
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			var width=$("#"+id).css("width");
			var width=width.substr(0,width.length-2)
			if (width>maxWidth) maxWidth=parseFloat(width)+2;
		}		
	})
	maxWidth=maxWidth+"px";
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			$("#"+id).css({"width":maxWidth})
		}		
	})
}

///Creator: zx
///CreatDate: 2018-09-02
///Description: hisui面板title样式定义
function defindTitleStyle()
{
	$(".hisui-panel").each(function(){
		var iconCls="";
		var headerCls=""
		var options=$(this).attr("data-options");
		if ((options!=undefined)&&(options!=""))
		{
			//转json格式
			options='{'+options+'}';
			var options=eval('('+options+')');
			var eqTitle=options.eqtitle;
			//add by zx 2019-05-16  ZX0065 面板默认会被清空问题修复
			if ((eqTitle==undefined)||(eqTitle=="")) return;
			switch(eqTitle){
				case "maintitle":
					iconCls="icon-apply-check";
					headerCls="panel-header-gray";
				break;
				case "listtitle":
					iconCls="icon-add-note";
					headerCls="panel-header-gray";
				break;
				case "defaulttitle":
					iconCls="icon-paper";
					headerCls="panel-header-gray";
				break;
				case "savetitle":
					iconCls="icon-save";
					headerCls="panel-header-gray";
				break;
				case "edittitle":
					iconCls="icon-write-order";
					headerCls="panel-header-gray";
				break;
				default :
				break;
			}
		}
		$HUI.panel(this,{
			iconCls:iconCls,
			headerCls:headerCls
		});
	});
	
}

///Creator: zx
///CreatDate: 2018-09-13
///Description 时间轴信息生成
///Input options={id:'lifeInfoView',section:'',item:'^^content1%eq-user.png^^content2%eq-user.png^^content1'}
///      id:父元素ul的id section:分区域模式 图标^内容;icon^content 
///      item:时间轴节点信息 图标^连接^内容;icon^url^content1%icon^url^content1%icon^url^content1
function createTimeLine(options)
{	
	var defaults = {
		id:'',
		section:'',
		item:'',
		lastFlag:'',
		onOrOff:'0'	//add by czf 2019-12-16 CZF0050
	};
    var options = jQuery.extend(defaults, options || {});
	if (options.id=="") return;
	var sectionHtml=""
	var html="";
	var liClass="eq-times-ul-li";
	if (options.onOrOff==1) liClass="eq-times-ul-li-off";	//add by czf 2019-12-16 CZF0050
	var curHtml=$("#"+options.id).html();
	if(options.section!="")
	{
		var sectionIcon=options.section.split("^")[0];
		var sectionContent=options.section.split("^")[1];
		sectionHtml=sectionHtml+'<div class="eq-times-section" style="background-image:url(../images/'+sectionIcon+')"><a>'+sectionContent+'</a></div>'; //年份不一样时增加年份分隔
	}
	// add by zx 2020-02-12 取消之前去掉最后元素边框的处理方式 ZX0073
	/*if (options.lastFlag!="")
	{
		if (curHtml=="") 
		{
			if(sectionHtml!="") liClass="eq-times-ul-li1";	//modified by czf 20190216 只有一个节点时时间轴样式
			else liClass="eq-times-ul-li-noneborder1";
		}
		else liClass="eq-times-ul-li-noneborder2";
	}*/
	var pointStyle="eq-times-point"; //默认点的样式
	if (options.onOrOff==1) pointStyle="eq-times-point-off";		//add by czf 2019-12-16 CZF0050
	if (curHtml=="")
	{
		pointStyle="eq-times-firstpoint";
		if (sectionHtml=="") html=html+'<li class="'+liClass+'" style="padding:0 0 10px 0;"><b class="'+pointStyle+'"></b>';
		else html=html+'<li class="'+liClass+'"><b class="'+pointStyle+'"></b>';
	}else{
		html=html+'<li class="'+liClass+'"><b class="'+pointStyle+'"></b>';
	}
	var singleItem=options.item.split("%");
	for (i=0;i<singleItem.length;i++)
	{
		var itemDetail=singleItem[i].split("^");
		var itemIcon=itemDetail[0];
		var itemUrl=itemDetail[1];
		var itemConten=itemDetail[2];
		if(itemIcon!=""){
			html=html+'<div class="eq-times-icon" style="background-image:url(../images/'+itemIcon+')">'+itemConten+'</div>';
		}else if(itemUrl!=""){
			html=html+'<p><a '+itemUrl+'>'+itemConten+'</a></p>';
		}else if(itemConten!=""){
			//add by czf 2019-12-16 CZF0050
			if (options.onOrOff==1) html=html+'<div style="color:#C0C0C0">'+itemConten+'</div>';
			else html=html+'<div>'+itemConten+'</div>';
		}
	}
	html=sectionHtml+html+'</li>';
	$("#"+options.id).append(html);
	//最后一个节点边框采用白色线条遮挡 add by zx 2020-02-12 ZX0073
	if (options.lastFlag!="") 
	{
		var lastLiHeight=$("#"+options.id+" li:last-child").innerHeight(); //获取最后一个节点高度
		var paddingValue=lastLiHeight/2; //遮罩元素的内边距处理
		var marginTopValue=-lastLiHeight+20; //遮罩元素上移距离
		$("#"+options.id).append('<li class="eq-times-ul-li-last" style="padding:'+paddingValue+'px 0px;margin-top:'+marginTopValue+'px;"></li>')
	}
}
///modified by ZY0215 2020-04-02 调整审批流程的显示
///Add By DJ 2018-09-14
function createApproveSchedule(vElementID,vApproveTypeCode,vSourceID)
{
	var ApproveSchedule=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetApproveSchedule",vApproveTypeCode,vSourceID)
	var ApproveScheduleObj=JSON.parse(ApproveSchedule)
	var ApproveScheduleInfo=ApproveScheduleObj["Data"]
	var ApproveFlow=ApproveScheduleInfo.split("^")
	///modified by ZY0215 2020-04-02 取当前步骤
	var Len=ApproveFlow.length
	var CurNode=""
	for (var i=0;i<Len;i++)
	{
		var OneInfo=ApproveFlow[i].split("=");
		if (OneInfo[1]==0)
		{
			CurNode=i
			break;
		}
	}
	var num=1	//定义当前步骤前后留几步
	var html="" 
	var FrontMore="",FrontValue=""
	var AfterMore="",AfterValue=""
	for (var i=0;i<Len;i++)
	{
		var OneInfo=ApproveFlow[i].split("=");
		if ((i!==0)&&((i!==(Len-1))))
		{
			//if ((CurNode!="")&&((i<(CurNode-2))||(i>(CurNode+2)))) continue
			if (i<(CurNode-num))
			{
				if (FrontValue=="") FrontValue=OneInfo[0]
				else FrontValue=FrontValue+","+OneInfo[0]
				var FrontMore="<a href='#' id='FrontMore' style=\"color: #40A2DE;font-size:16px;padding:0 10px 0px 10px;\">更多...</a><a><img src='../images/eq-line-2.png'></a>"
				continue
			}
			else if ((i>(CurNode+num)))
			{
				if (AfterValue=="") AfterValue=OneInfo[0]
				else AfterValue=AfterValue+","+OneInfo[0]
				//href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark"
				var AfterMore="<a href='#' id='AfterMore' style=\"color: #C0C0C0;font-size:16px;padding:0 10px 0px 10px;\">更多...</a><a><img src='../images/eq-line-1.png'></a>"
				continue
			}
		}
		if ((i>(CurNode-num)))FrontMore=""
		var captionhtml="<a style=\"color: #C0C0C0;font-size:16px;padding:0 10px 0px 10px;\">"+OneInfo[0]+"</a>"
		var imghtml="<a><img src='../images/eq-line-1.png'></a>"
		if (OneInfo[1]==1)
		{
			captionhtml="<a style=\"color: #40A2DE;font-size:16px;padding:0 10px 0px 10px;\">"+OneInfo[0]+"</a>"
			imghtml="<a><img src='../images/eq-line-2.png'></a>"
		}
		
		if (i==0)
		{
			html=captionhtml+imghtml
		}
		else if (i==(ApproveFlow.length-1))
		{
			if (AfterMore!="")  html=html+imghtml+AfterMore
			html=html+imghtml+captionhtml
		}
		else
		{
			if (FrontMore!="")  html=html+imghtml+FrontMore
			html=html+imghtml+captionhtml+imghtml
		}
	}
	$("#"+vElementID).append(html);
	//modified by ZY0215 2020-04-02 添加tooltip显示
	setTooltip("FrontMore",FrontValue)
	setTooltip("AfterMore",AfterValue)
}
///增加: zhangyu
///日期: 2018-09-30
///bugZY0170
///描述: 计算datagrid某列的合计
///Input: dgId   datagrid的ID
///       colName 列
function totalSum(dgId,colName) {
    var rows = $('#'+dgId).datagrid('getRows');
    var total = 0;
    for (var i = 0; i < rows.length; i++) {
        var colValue=rows[i][colName]
        if (colValue=="") colValue=0
        total += parseFloat(colValue);
    }
    return total;
}

///增加: zhangyu
///bugZY0170
///日期: 2018-09-30
///描述: 生成datagrid列的formatter 属性需要的html 
///Input: value  
///       row			行对象
///       index			行索引
///       oneItem		一个元素对象
///modify by lmm 2019-02-17 更改window弹窗为modal弹窗 增加弹窗宽，高，图标，标题，尺寸定义
///modify by lmm 2019-02-19 增加ShowInNewWindow属性 fun 回调函数
function oneFormatterHtml(value,row,index,oneItem)
{
	var html=""
	if (oneItem.TDisplayType=="1" )
	{
		var str=oneItem.TLinkExpression
		var newWidth=""
		var newHeight=""
		var newTitle="详细"
		var newIcon="icon-w-paper"
		var newSize=""
		var newFun=""
		var showInNewWindow=oneItem.TShowInNewWindow
		if (showInNewWindow!="")
		{
			var newWindowInfo=showInNewWindow.split(",")
			for (var i=0;i<newWindowInfo.length;i++)
			{
				var oneInfo=newWindowInfo[i].split("=")
				if (oneInfo[0]=="width")
				{
					newWidth=oneInfo[1]
				}
				else if (oneInfo[0]=="height")
				{
					newHeight=oneInfo[1]
				}
				else if (oneInfo[0]=="title")
				{
					newTitle=oneInfo[1]
				}
				else if (oneInfo[0]=="icon")
				{
					newIcon=oneInfo[1]
				}
				else if (oneInfo[0]=="size")
				{
					newSize=oneInfo[1]
				}
				else if (oneInfo[0]=="fun")
				{
					newFun=oneInfo[1]
				}
			}
		}
		//add by lmm 2019-02-20 begin
		if (newFun=="")
		{
			newFun="&quot;&quot;"
			
		}
		//add by lmm 2019-02-20 end
		//var str="'&RowID='_rs.GetDataByName('msgID')_'&ReadOnly='_%Request.Get('ReadOnly')_'&vData='_%Request.Get('vData')_'&actionDesc='_rs.GetListDataByName('actionDesc')_'&actionCode='_rs.GetListDataByName('actionCode')_'&roles='_rs.GetListDataByName('roles')"
		//Modify By zx 2020-02-20 BUG ZX0076 可以不传参定义调用js函数
		if(typeof(str)=="undefined" || str=="")
		{
			if (oneItem.TLookupJavascriptFunction!="")
			{
				//Modify by zx 2020-04-22 BUG ZX0084
				if(oneItem.TTooltip=="")
				{
					html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')">'+oneItem.TDescription+'<img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'"/></a>'
				}
				else
				{
					html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')" title='+oneItem.TTooltip+' class="hisui-tooltip" data-options="position:'+"'bottom'"+'">'+oneItem.TDescription+'<img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'"/></a>';
				}
			}
			return html;
		} 
		str=str.replace(/'/g,"")	//去掉单引号
		str=str.replace(/_/g,"")	//去掉空下划线
		str=str.replace(/%Request.Get/g,"%")	//去掉
		str=str.replace(/rs.GetDataByName/g,"#")	//去掉
		str=str.replace(/rs.GetListDataByName/g,"@")	//去掉
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
				para=para+"&"+oneArgName+"="+getElementValue(oneArgValueDesc)
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
		var url=oneItem.TLinkUrl
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
   			 	html=html+'<A onclick="showWindow(&quot;'+oneurl+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#" style="margin-left:5px">'+name+'</A>';
			}
		}
		else
		{
			//html='<A onclick="openNewWindow(&quot;'+url+'&quot;,&quot;'+oneItem.TShowInNewWindow+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/'+oneItem.TImage+'" /></A>';
			if (oneItem.TImage!="")
			{
				//modified by zy 20190612 ZY0190
				if (oneItem.TTooltip==""){
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'"/></A>';
				}
				else{
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#" title='+oneItem.TTooltip+' class="hisui-tooltip" data-options="position:'+"'bottom'"+'"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'" /></A>';
				}
			}
			else
			{
				if  (oneItem.TDescription!="")
				{
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#">'+oneItem.TDescription+'</A>';
				}
				else
				{
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#">'+value+'</A>';
				}
			}
		}
	}
	return html
}
///Add By JYP 2018-10-09
///描述:根据元素串分别移除元素的必填项属性.
///入参:vElementIDs 需要所移除必填项的元素名串 格式:"元素名1^元素名2^.....^元素名n"
///返回值:无
///说明:setItemRequire为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function removeRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],false)
	}
}
///增加: zhangyu
///bugZY0170
///日期: 2018-09-30
///描述: 移除一个Datagrid中勾选中需要删除的行
///Input: datagridID table id
function removeCheckBoxedRow(datagridID)
{ 
	var deleteRows=new Array();
	deleteRows=$('#'+datagridID).datagrid('getChecked');
	for(var i=0;i<deleteRows.length;i++)
	{
		var deleteRow=deleteRows[i];
		var deleteIndex=$('#'+datagridID).datagrid('getRowIndex',deleteRow);
		$('#'+datagridID).datagrid('deleteRow',deleteIndex)
	}
}

///add by lmm 2018-10-22
///描述：必填项下拉框DR校验
///入参：Strs不为空时对Strs中的必填元素不做DR是否为空的验证
///modify by lmm 2018-10-23 更改if判断顺序
function checkMustLookupDRNull(Strs)
{
	var CValue=""
	$('input[type="HIDDEN"]').each(function(){
		var _t = $(this);
		var id = _t.attr("id");
		//console.log(id);  //modify by jyp 2018-12-28 控制台调试打印去掉
		var lookupId=""
		var id=String(id)
		if(id.lastIndexOf("_")>=0)
		{
			var lookupId=$("#"+id.substr(0,id.lastIndexOf("_"))).attr("id")	
		}		
		else if ($("#"+id.substr(0,id.length-2)).attr("id")!=undefined)
		{
			var lookupId=$("#"+id.substr(0,id.length-2)).attr("id")
		}
		if (($("#"+lookupId).attr("data-required")=="true")&&(_t.attr("value")==""))
		{
			if(Strs!=""&&Strs!=undefined)		//modified by czf 773715
			{
				if(StrIsInStrs(Strs,lookupId,"^")&&(trim(GetElementValue(lookupId))!=""))
				{
					return false;
				}
			}
			$("#"+lookupId+",#"+lookupId+"+span>.validatebox-text").addClass("validatebox-invalid");
			CValue=getElementValue("c"+lookupId);

			return false;
		}
		
	})	
	if(CValue!="")
	{
		messageShow("","","",CValue+t[-9201]);
		return true;	
	}
}
/// 描述：弹框统一调用
/// add by zx 2018-10-31
/// 参数：
/// 	url:弹窗调用url
/// 	title:窗口标题
/// 	width:宽度,百分比
/// 	height:高度,百分比
/// 	icon:图标
/// 	showtype:窗口样式 modal:模态窗, window:window窗体, dialog:普通窗体即非模态窗
/// 	left:弹框距左边距离 为空时纵向居中,支持百分比赋值。
/// 	top:弹框距上边距离 为空时纵向居中,支持百分比赋值。
///     size:弹窗尺寸 large:大弹窗90% middle：默认弹窗80% small：小弹窗 60% 70%
///     cfun：调用方法
/// add by zx 2018-11-30 高度改为按浏览器窗口的百分比
/// add by zx 2019-01-24 宽,高度获取改为取可见区域及增加弹框定位参数
/// add by lmm 2019-02-17 增加弹窗大小定义
/// add by lmm 2019-02-19 增加调用方法
/// modify by lmm 2020-06-02
/// 新增height:3row(3行)  width:3col(3列)   size:fix1col  fix2col  fix3col  fix4col  fix4col(固定列弹窗)
function showWindow(url,title,width,height,icon,showtype,left,top,size,cfun)
{
	//add by lmm 2020-06-02	
	if ((height!="")&&(height.toString().indexOf("row")>0))
	{
		var len=height.split("row")[0];
		
		var subrowheight="43.75"
		var height=subrowheight*len
		
	}
	if ((width!="")&&(width.toString().indexOf("col")>0))
	{
		var len=width.split("col")[0];
		//var subcolwidth="370"
		//var width=subcolwidth*len
		switch(len){
			case '1':width="400"; break;
			case '2':width="650"; break;
			case '3':width="1000"; break;
			case '4':width="1350"; break;   //modify by lmm 2020-06-11
			case '5':width="1600"; 	break;	
			default:width="1600"; 	break;
		}
		
		
		
	}

	//add by lmm 2020-06-11 网页宽高
	var htmlWidth=window.top.document.documentElement["clientWidth"]
	var htmlHeight =window.top.document.documentElement["clientHeight"]
	if (!(showtype)||(showtype=="")) showtype="modal"
	switch(showtype){
		//modify by lmm 2019-02-14 组内方法不使用
		/*
		case 'modal':
		if (width==""){width=$(window).width()*0.85; }
		else if (width.toString().indexOf("%")>0){
				//弹出窗口的宽度;
				width=width.replace("%","")/100;
				width=$(window).width()*width; 
			}
		if (height==""){height=$(window).height()*0.9; }    
		else if (height.toString().indexOf("%")>0){
				//弹出窗口的高度;
				height=height.replace("%","")/100;
				height=$(window).height()*height;
			}
			//生成模态窗div 避免同一窗口打开不通模态窗不居中
			//id改为跟组件弹窗一致,便于调通一方法关闭模态窗
			$(document.body).append('<div id="WinModalEasyUI" style="overflow:hidden;"></div>');
			$("#WinModalEasyUI").show();
			$HUI.window("#WinModalEasyUI",{
				iconCls:icon,
				resizable:true,
				width:width,
		        height:height,
				modal:true,
				closed: false,
				title:title,
				collapsible:false,  //add by zx 2019-01-24 
				minimizable:false,
				maximizable:false,
				left:left,
				top:top,
				onClose: function () {
					//关闭是移除模态窗div
			        $("#WinModalEasyUI").remove();
			    },
				content:'<iframe src="'+url+'" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>',
			});
			break;
			*/
		case 'window':
			var features="width="+width+",height="+height;  //宽高为百分比
			websys_createWindow(url,title,features);   //平台方法
			break;
		case 'modal':
			if (size=="verylarge")   {  if (width=="") width="1600"; if (height=="") height ="800"}
			if (size=="large")   {  if (width=="") width="1350"; if (height=="") height ="800"}   //modify by lmm 2020-06-11
			if (size=="middle")   {  if (width=="") width="1000"; if (height=="") height ="700"}
			if (size=="small")   {  if (width=="") width="650"; if (height=="") height ="700"}
			//modify by lmm 2020-06-11	弹窗超出网页重设宽高
			
			if (width>htmlWidth)
			{
				width=htmlWidth-50;
			}			
			if (height>htmlHeight)
			{
				height=htmlHeight-50;
			}

			//add by lmm 2020-06-02
			//5列固定弹窗
			var options={
					url:url,
					title:title,
					iconCls:icon,
					modal:true,   //模态窗
					left:left,
					top:top,
					mth:cfun      //add by lmm 2019-02-19
				}
				
			if (width!=="") options.width=width	
			if (height!=="") options.height=height
				
			websys_showModal(options);  
			break;
		case 'dialog':	
			if (size=="verylarge")   {  if (width=="") width="1600"; if (height=="") height ="800"}
			if (size=="large")   {  if (width=="") width="1350"; if (height=="") height ="850"}   //modify by lmm 2020-06-11
			if (size=="middle")   {  if (width=="") width="1000"; if (height=="") height ="700"}
			if (size=="small")   {  if (width=="") width="650"; if (height=="") height ="700"}
			//add by lmm 2020-06-02
			//5列固定弹窗
			//modify by lmm 2020-06-11	弹窗超出网页重设宽高
			if (width>htmlWidth)
			{
				width=htmlWidth-50;
			}			
			if (height>htmlHeight)
			{
				height=htmlHeight-50;
			}
			var options={
					url:url,
					title:title,
					iconCls:icon,
					modal:false,   //非模态窗
					left:left,
					top:top,
					mth:cfun      //add by lmm 2019-02-19
				}
			if (width!=="") options.width=width	
			if (height!=="") options.height=height				
			websys_showModal(options);  
				
			break;
		default:
			break;
	}
}
///Add By DJ 2018-11-02
function createdatagrid(componentID,queryParams,columns)
{
	$HUI.datagrid("#"+componentID,{
		url:$URL,
		queryParams:queryParams,
		fit:true,
		striped : true,
	    cache: false,
		fitColumns:true,
		columns:columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){LoadSuccess();}
	});
}

///add by zx 2018-11-20
/// 弹窗关闭处理
function closeWindow(type)
{
	switch(type){
		case 'modal':
			//parent.$('#WinModalEasyUI',parent.document).dialog('close'); modiied by czf 20190219
			websys_showModal("close");	
			break;
		default:
			break;
	}
}

///add by lmm 2019-02-20
///界面刷新
function refreshWindow()
{
	location.reload();	

}


/// add by lmm 2019-09-01
/// 描述:hisui表单界面实现回车下一个输入框 
/// 备注:文本框,下拉框,下拉列表,日期框,时间框中实现,大文本框不支持
/// modify by lmm 2020-06-29 去除lookup回车情况
function muilt_Tab()
{
	var inputs=$("input[class^=hisui-][disabled!=disabled],select[class^=hisui-][disabled!=disabled]")	
	$("input[disabled!=disabled],select[disabled!=disabled]").keyup(function(){  
		var obj=$(this)
		var className = obj.prop("className");
		var curID=obj.parent().children(":first").attr("id");
		if (className.indexOf("combo-text") != -1) curID=obj.parent().parent().children(":first").attr("id");
		var event = event||window.event;
		var keyCode=event.which||event.keyCode
		if (keyCode==13)
		{
			if (tabflag==0)
			{
				for(var i = 0;i<inputs.length;i++)
				{    
					if ((curID==inputs[i].id)&&(inputs[i].className.indexOf("lookup") == -1))
					{
						// 如果是最后一个，则焦点回到第一个 
						if(i==(inputs.length-1))
						{   
							 if ((inputs[0].className.indexOf("combobox-f") != -1)||(inputs[0].className.indexOf("datebox-f") != -1))
							 {
								$("#"+inputs[0].id).next('span').find('input').focus()
							}
							else if (inputs[i].className.indexOf("lookup") == -1)
							{
								inputs[0].focus()
							}
							
						}
						 else
						{    
							 if ((inputs[i+1].className.indexOf("combobox-f") != -1)||(inputs[i+1].className.indexOf("datebox-f") != -1))
							 {
								$("#"+inputs[i+1].id).next('span').find('input').focus()
							}
							else
							{
								inputs[i+1].focus()
								
							}
						}	
					}
				}
			}
			else
			{tabflag=0}
	}
	});		
}
/// 描述：标准lookup回调函数写值处理
///仅可用于，ID的Name为TRowID，且Desc元素名为ID元素名+'_***'这种
/// 例如  BRManageLocDR_CTLOCDesc  和  BRManageLocDR   对应的PLAT.L.Loc可以使用
/// add by ZY0197 2019-11-27
/// 参数：
/// 	elementID:处理对象的元素ID
/// 	rowData:选择的弹出框行对象
function setDefaultElementValue(elementID,rowData)
{
	var elementID=elementID.substr(0,elementID.lastIndexOf("_"))
	setElement(elementID,rowData.TRowID)
}
//add by csj 2019-10-14
//根据可编辑字段动态设置列表可编辑输入框
//入参：datagrid列表jQuery对象(例：$('#DHCEQBuyPlan')）
//返回值 -1：无可编辑列表字段 0：正常
function setListEditable(objtbl)
{
	if(ObjEditFields.length>0){
		var dataGridColums = objtbl.datagrid("options").columns[0]
		var ListNameStr ="" 	//列表可编辑字段拼串
		for(var i = 0;i < ObjEditFields.length; i++)
		{
			if(ObjEditFields[i].ListFlag=="N") continue
			ListNameStr==""?ListNameStr=ObjEditFields[i].FieldName:ListNameStr=ListNameStr+getElementValue("SplitRowCode")+ObjEditFields[i].FieldName
		}
		if(ListNameStr=="") return -1
		for(var i = 0;i < dataGridColums.length; i++){
			if(ListNameStr.indexOf(dataGridColums[i].field)==-1){
				dataGridColums[i].editor=undefined
			};
		}
		return 0
	}
	else return -1
}

//add by ZY0215 2020-04-02 
//根据业务ID获取审批记录,生成时间轴
//入参：vElementID 界面的元素
//		vBussType 业务代码
//		vBussID 业务ID
function createApproveRecord(vElementID,vBussType,vBussID)
{
    var resultData=$.cm({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		QueryName:"GetApproveList",
		BussType:vBussType,
		SourceID:vBussID
		},false)
	$("#"+vElementID).empty();
	//var curYear=""
	//按时间倒序,从最大值遍历
	for (var i=0;i<resultData.rows.length;i++)
	{
		var oneRecord=resultData.rows[i];
		var statusFlag=0
		var keyInfo=oneRecord.TApproveUser+" "+oneRecord.TAction+"，审批意见："+oneRecord.TOpinion
		if (oneRecord.TOperateType==1) keyInfo=oneRecord.TApproveUser+" "+oneRecord.TAction+"，拒绝，拒绝原因："+oneRecord.TOpinion
		if (oneRecord.TApproveRole!="") keyInfo=oneRecord.TApproveRole+" "+keyInfo
		var section="";
		var flag="";
		if(i==resultData.rows.length-1) flag=1;
		var ApproveDate=oneRecord.TApproveDate+" "+oneRecord.TApproveTime
		var ApproveInfo=""
		if(ApproveDate!=" ") 
		{
			ApproveInfo=ApproveDate+"，"+keyInfo
			opt={
				id:vElementID,
				section:section,
				item:'^^'+'%^^'+ApproveInfo,
				lastFlag:flag,
				onOrOff:statusFlag
			}
			createTimeLine(opt);
		}
	}
}

///add by lmm 2020-06-04
///描述：导出列专用弹窗
function colSetWindows(url)
{
	showWindow(url,"导出列设置","","","icon-w-paper","","","","middle")  	
}
///Add By ZC0077 2020-06-24
///描述:根据元素串分别取消元素设置的必填项属性.
///入参:vElementIDs 需要所取消设置必填项的元素名串 格式:"元素名1^元素名2^.....^元素名n"
///返回值:无
///说明:setItemRequire为平台公共函数.位置:"scripts/hisui/websys.hisui.js"
function RemoveRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],false)
	}
}