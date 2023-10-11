Ext.namespace("Ext.BDP.FunLib"); //注册基础数据平台函数库
Ext.namespace("Ext.BDP.FunLib.Component");
Ext.namespace("Ext.BDP.FunLib.Path");
Ext.namespace("Ext.BDP.FunLib.PageSize");
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/websys.comm.ext.js"> </script>');
Ext.BDP.FunLib.Path.URL_Icon = "../scripts/bdp/Framework/icons/";   //图标基本路径 
Ext.BDP.FunLib.Path.URL_Img = "../scripts/bdp/Framework/imgs/";   //图标基本路径 
Ext.BDP.FunLib.Path.URL_BdpIcon = "../scripts/bdp/Framework/BdpIconsLib/";   //图标基本路径 

Ext.BDP.FunLib.TableName = "";
Ext.BDP.FunLib.SelectRowId = "";

//ajax调用增加token参数 20230214
if("undefined"!=typeof websys_getMWToken){
	Ext.Ajax.addListener("beforerequest", function(conn, options, eOpts ){
	    if(options){
	        var nParam = options.params;
	        if (nParam != undefined) {
				nParam.MWToken = websys_getMWToken()
	        }
	    }
	}, this);
}
function AutogetPagesize() {
    if(window.top.document.getElementById("centerPanel")!=null&&window.top.document.getElementById("centerPanel")!=undefined)
    {	
		outerHeight=parseInt(window.top.document.getElementById("centerPanel").style.height)-140;
    }
    else
    {
		var outerHeight=$(window).height()	
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		var s;
		(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
		if(Sys.chrome){
			//outerHeight = $(window).height() - 122;
			outerHeight = $(window).height() -68;
		}
		else{
		  //outerHeight = $(window).height() - 80; 
			outerHeight = $(window).height() - 36; 
		}
    }
    
	var count=outerHeight/28.4  //每行数据的高度为28.4
	var pagesize=parseInt(count/5)*5  //取整(5的倍数)
	return pagesize
}
var MainFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForMain");
var PopFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForPop");
var AutFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForAut");
var ComboFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForCombo");

var AutogetPagesizeflag=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","AutoPageSize");
if(AutogetPagesizeflag!="Y"){
	(MainFalg == "") ? Ext.BDP.FunLib.PageSize.Main=20 : Ext.BDP.FunLib.PageSize.Main = parseInt(MainFalg);
}
else{
	Ext.BDP.FunLib.PageSize.Main=AutogetPagesize()
}

(PopFalg == "") ?  Ext.BDP.FunLib.PageSize.Pop=12 : Ext.BDP.FunLib.PageSize.Pop = parseInt(PopFalg);
(AutFalg == "") ?  Ext.BDP.FunLib.PageSize.Aut=20 : Ext.BDP.FunLib.PageSize.Aut = parseInt(AutFalg);
(ComboFalg == "") ?Ext.BDP.FunLib.PageSize.Combo=10 : Ext.BDP.FunLib.PageSize.Combo =parseInt(ComboFalg);
Ext.Ajax.timeout = 36000000;   ///ajax前台默认请求时间为30s 部分数据请求较多时会超长。
/*Ext.BDP.FunLib.PageSize.Main = 20;  
Ext.BDP.FunLib.PageSize.Pop = 12;
Ext.BDP.FunLib.PageSize.Aut = 20;
Ext.BDP.FunLib.PageSize.Combo = 10;*/

Ext.BDP.FunLib.version = " V2.1.14";

Ext.BDP.FunLib.Component.BDPInternalCodeHiddenFlag=true;	 
Ext.BDP.FunLib.Component.BDPInternalDescHiddenFlag=true;
Ext.BDP.FunLib.Component.BDPHospNationalCodeHiddenFlag=true;
Ext.BDP.FunLib.Component.BDPPHospNationalDescHiddenFlag=true;

/// 去除compositeField的逗号间隔标志
Ext.BDP.FunLib.Component.CompositeField  = Ext.extend(Ext.form.CompositeField ,{
	  buildLabel: function(segments) {
        return segments.join("");
     },
     labelSeparator:""
});
Ext.reg("compositefield",Ext.BDP.FunLib.Component.CompositeField);

///textfield,textarea,numberfield,datefield,checkbox,trigger,timefield,combo,bdpcombo  htmleditor TreeCombo  CheckboxGroup
///  multiSelect   BoxComponent  radio  radiogroup

//去掉输入框前面的冒号
//文本输入框
Ext.BDP.FunLib.Component.TextField = Ext.extend(Ext.form.TextField,{
	   labelSeparator:""
	});
Ext.reg("textfield",Ext.BDP.FunLib.Component.TextField);

//基本下拉框  注意是  BaseComboBox
Ext.BDP.FunLib.Component.BaseComboBox = Ext.extend(Ext.form.ComboBox,{
	   labelSeparator:""
	});
Ext.reg("combo",Ext.BDP.FunLib.Component.BaseComboBox);


//复选框
Ext.BDP.FunLib.Component.Checkbox = Ext.extend(Ext.form.Checkbox,{
	   labelSeparator:""
	});
Ext.reg("checkbox",Ext.BDP.FunLib.Component.Checkbox);

//日期选择框
Ext.BDP.FunLib.Component.DateField = Ext.extend(Ext.form.DateField,{
		labelSeparator:"",
		enableKeyEvents : true,
		listeners : {
			'keyup' : function(field, e){
				Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
			}
		}
	});
Ext.reg("datefield",Ext.BDP.FunLib.Component.DateField);

//数字输入框
Ext.BDP.FunLib.Component.NumberField = Ext.extend(Ext.form.NumberField,{
	   labelSeparator:""
	});
Ext.reg("numberfield",Ext.BDP.FunLib.Component.NumberField);

//时间输入框
Ext.BDP.FunLib.Component.TimeField = Ext.extend(Ext.form.TimeField,{
	   labelSeparator:""
	});
Ext.reg("timefield",Ext.BDP.FunLib.Component.TimeField)

//trigger  (医嘱项里收费项目代码）
Ext.BDP.FunLib.Component.TriggerField = Ext.extend(Ext.form.TriggerField,{
	   labelSeparator:""
	});
Ext.reg("trigger",Ext.BDP.FunLib.Component.TriggerField)


//多行文本
Ext.BDP.FunLib.Component.TextArea = Ext.extend(Ext.form.TextArea,{
	   labelSeparator:""
	});
Ext.reg("textarea",Ext.BDP.FunLib.Component.TextArea);


//box（菜单选择图标）
Ext.BDP.FunLib.Component.BoxComponent = Ext.extend(Ext.BoxComponent,{
	   labelSeparator:""
	});
Ext.reg("box",Ext.BDP.FunLib.Component.BoxComponent);


///复选框分组
Ext.BDP.FunLib.Component.CheckboxGroup = Ext.extend(Ext.form.CheckboxGroup,{
	   labelSeparator:""
	});
Ext.reg("checkboxgroup",Ext.BDP.FunLib.Component.CheckboxGroup);


//单选框
Ext.BDP.FunLib.Component.Radio = Ext.extend(Ext.form.Radio,{
	   labelSeparator:""
	});
Ext.reg("radio",Ext.BDP.FunLib.Component.Radio);

//单选框分组
Ext.BDP.FunLib.Component.RadioGroup = Ext.extend(Ext.form.RadioGroup,{
	   labelSeparator:""
	});
Ext.reg("radiogroup",Ext.BDP.FunLib.Component.RadioGroup);

//displayfield 可以有冒号





/**用于Grid中返回是否图片**/
//蔡昊哲  2012-11-15
Ext.BDP.FunLib.Component.ReturnFlagIcon = function(value)
{
  	if(value=='Y')
  		{
			return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"yes.png' style='border: 0px'/>";
  		}
  	else if(value=='N')
  		{
			return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"no.png' style='border: 0px'/>";
		}
    else 
 	 	{
			return "";
		}
}

/**创建DisableArray,用于控制控件是否可使用 **/
Ext.BDP.FunLib.Component.DisableArray = new Array(); 

/**创建HiddenArray，用于控制控件是否隐藏 **/
Ext.BDP.FunLib.Component.HiddenArray = new Array(); 

/**用于返回是控件否可编辑Flag**/
//蔡昊哲  2012-11-28
Ext.BDP.FunLib.Component.DisableFlag = function(ControlId){
	if(typeof(Ext.BDP.FunLib.Component.DisableArray) != 'undefined')
	{
		
		if((Ext.BDP.FunLib.Component.DisableArray[ControlId] == false) || (Ext.BDP.FunLib.Component.DisableArray[ControlId] == "N"))
		{			
			return true;
		}
		else 
		{
			return false;
		}
	}
	else
	{
		return false;
	}
};

/**用于返回是控件否隐藏 Flag**/
//蔡昊哲  2012-11-29
Ext.BDP.FunLib.Component.HiddenFlag = function(ControlId){
	if(typeof(Ext.BDP.FunLib.Component.HiddenArray) != 'undefined')
	{
		if((Ext.BDP.FunLib.Component.HiddenArray[ControlId] == true) || (Ext.BDP.FunLib.Component.HiddenArray[ControlId] == "true"))
		{			
			return true;
		}
		else 
		{
			return false;
		}
	}
	else
	{
		return false;
	}
};
/// 屏蔽系统esc强制关闭窗口的功能,用于子表重置时的调用
Ext.BDP.FunLib.Component.stopDefaultEsc=function(win){
	win.onEsc = function() {  
	return false;  
 }  
}

/**解析DisableAndHiddenJsonString，存入对应数组中以备使用。**/
/**参数格式 "{ControlId1:{Disable:'Y',Hidden:'N'},ControlId2:{Disable:'Y',Hidden:'N'}}";**/
/**使用方法 Ext.BDP.FunLib.Component.SetPropertyValue(DisableJsonString)**/
//蔡昊哲  2012-11-29
Ext.BDP.FunLib.Component.SetPropertyValue = function(DisableAndHiddenJsonString){
	try 
	{
	     var jsonObj = Ext.util.JSON.decode(DisableAndHiddenJsonString);   //解析JSON，存入对象变量jsonObj中
	     for(var n in jsonObj)                                    //遍历JsonObj，摘取所需要的信息存到对应数组中
	     {
	     	if(jsonObj[n].Disable!='undefined')                  
	     	{
	     		Ext.BDP.FunLib.Component.DisableArray[n] = jsonObj[n].Disable;
	     	}
	     	if(jsonObj[n].Hidden!='undefined')                  
	     	{
	     		Ext.BDP.FunLib.Component.HiddenArray[n] = jsonObj[n].Hidden;
	     	}
          	//alert(n+','+jsonObj[n].Disable +','+jsonObj[n].Hidden);  //弹出解析后的数据，用于测试	     	
      	 }
      	 return "ok";
	} 
	catch (e) 
	{  
		return "error" + e;	
	}
}

/**快捷键KeyMap的封装方法**/
/**参数解释 AddData: 新增,UpdateData:修改，DelData：删除**/
/**使用方法   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器，否则可能会报错
    {
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData,Refresh);
    } 
   参数为自己JS中对应的方法名 **/
	//高姗姗 2015-11-23
	function getNextInput(input)
	{
		var form=input.form;
		if (form!=null)
		{
			for( var i=0; i<form.elements.length; i++)
			{
				if (form.elements[i]==input)
				{
					break;
				}
			}
			while(true)
			{
				if (i++<form.elements.length)
				{
					if (form.elements[i].type!="hidden")
					{
						return form.elements[i];
					}
				}
				else
				{
					return null;
				}
			}
		}else{
			var inputList=document.getElementsByTagName('input');
			for (i = 0; i < inputList.length; i++) {
				if (inputList[i] == document.activeElement) {
					nextindex = i + 1;
					break;
				}
			}
			while(true){
				if (nextindex <= inputList.length) {
					return inputList[nextindex];
				}else{
					return null;
				}
			}
		}
	}

///////////////////////////////// 自定义快捷键功能 sunfengchao//////////////////////////
Ext.BDP.FunLib.StopDefault=function(e) {  
        //如果提供了事件对象，则这是一个非IE浏览器   
        if(e && e.preventDefault) {  
        　　//阻止默认浏览器动作(W3C)  
       		e.keyCode = 0;
			e.returnValue = false;
        　　	e.preventDefault();  
        } 
        else {  　　//IE中阻止函数器默认动作的方式  
          	e.keyCode = 0;
		  	e.returnValue = false;
        　　	window.event.returnValue = false;   
        }  
        
       //如果提供了事件对象，则这是一个非IE浏览器  
	    if(e && e.stopPropagation) {  
	  　　//因此它支持W3C的stopPropagation()方法  
	  　　e.stopPropagation();   
	    } else {  
	  　　//否则，我们需要使用IE的方式来取消事件冒泡   
	  　　window.event.cancelBubble = true;  
	    }  
        return false;  
  }  
 
 
/// 键盘码库
Ext.BDP.FunLib.GetKeyByKeyCode=function(keycode)
{
	var KeyValue="";
	switch (keycode){
	case 8: KeyValue="BackSpace";
			return KeyValue;
			break;
	case 16: KeyValue="Shift";
			return KeyValue;
			break;
	case 17: KeyValue="Ctrl";   
			return KeyValue;
			break;
	case 18: KeyValue="Alt"; 
			return KeyValue;
			break;	
	case 9: KeyValue="Tab";	
			return KeyValue;
			break;  
	case 12: KeyValue="Clear";	 
			return KeyValue;
			break;
	case 13: KeyValue="Enter";	 
			return KeyValue;
			break;
			
 	case 19: KeyValue="Pause"; 
		 	return KeyValue;
			break;
	case 20: KeyValue="CapsLk";
		 	return KeyValue;
			break;
	case 27: KeyValue="Escape"; 
			return KeyValue;
			break;
	/*case 32: KeyValue="space";
			return KeyValue;
			break;  */
	case 33: KeyValue="Prior"; 
			return KeyValue;
			break;
	case 34: KeyValue="Next";
			return KeyValue;
			break;
	case 35: KeyValue="End";
			return KeyValue;
			break; 
	case 36: KeyValue="Home";
			return KeyValue;
			break;
	case 37: KeyValue="Left";
			return KeyValue;
			break;
	case 38: KeyValue="Up";
			return KeyValue;
			break;
	case 39: KeyValue="Right";
			return KeyValue;
			break;
	case 40: KeyValue="Down";
			return KeyValue;
			break;
	case 41: KeyValue="Select";
			return KeyValue;
			break;
	case 42: KeyValue="Print";
			return KeyValue;
			break;
	case 43: KeyValue="Execute";
			return KeyValue;
			break;
	case 45: KeyValue="Insert";
			return KeyValue;
			break;
	case 46: KeyValue="Delete";
			return KeyValue;
			break;
	case 47: KeyValue="Help";
			return KeyValue;
			break;  
	case 65: KeyValue="A"; 
		 	return KeyValue;
			break;
	case 66: KeyValue="B";
			return KeyValue;
			break;
	case 67: KeyValue="C";
			return KeyValue;
			break;
	case 68: KeyValue="D"; 
			return KeyValue;
			break;
	case 69: KeyValue="E";
			return KeyValue;
			break;
	case 70: KeyValue="F";
			return KeyValue;
			break;
	case 71: KeyValue="G"; 
			return KeyValue;
			break;
	case 72: KeyValue="H"; 
			return KeyValue;
			break;
	case 73: KeyValue="I";
			return KeyValue;
			break;
	case 74: KeyValue="J";
			return KeyValue;
			break;
	case 75: KeyValue="K";
			return KeyValue;
			break;
	case 76: KeyValue="L";	
			return KeyValue;
			break;
	case 77: KeyValue="M";
			return KeyValue;
			break;
	case 78: KeyValue="N";
			return KeyValue;
			break;
	case 79: KeyValue="O";
			return KeyValue;
			break;
	case 80: KeyValue="P";
			return KeyValue;
			break;
	case 81: KeyValue="Q";
			return KeyValue;
			break;
	case 82: KeyValue="R";
			return KeyValue;
			break;
	case 83: KeyValue="S";
			return KeyValue;
			break;
	case 84: KeyValue="T";
			return KeyValue;
			break;
	case 85: KeyValue="U";
			return KeyValue;
			break;
	case 86: KeyValue="V";
			return KeyValue;
			break;
	case 87: KeyValue="W";
			return KeyValue;
			break;
	case 88: KeyValue="X";
			return KeyValue;
			break;
	case 89: KeyValue="Y";
			return KeyValue;
			break;
	case 90: KeyValue="Z";
			return KeyValue;
			break;  
	case 112: KeyValue="F1";
			return KeyValue;
			break;
	case 113: KeyValue="F2";
			return KeyValue;
			break;
	case 114: KeyValue="F3";
			return KeyValue;
			break;
	case 115: KeyValue="F4";
			return KeyValue;
			break;
	case 116: KeyValue="F5";
			return KeyValue;
			break;
	case 117: KeyValue="F6";
			return KeyValue;
			break;
	case 118: KeyValue="F7";
			return KeyValue;
			break;
	case 119: KeyValue="F8";
			return KeyValue;
			break;
	case 120: KeyValue="F9";
			return KeyValue;
			break;
	case 121: KeyValue="F10";
			return KeyValue;
			break;
	case 122: KeyValue="F11";
			return KeyValue;
			break;
	case 123: KeyValue="F12";
			return KeyValue;
			break;
	case 124: KeyValue="F13";
			return KeyValue;	
			break;
	case 125: KeyValue="F14";
			return KeyValue;	
			break;
	case 126: KeyValue="F15";
			return KeyValue;	
			break;
	case 127: KeyValue="F16";
			return KeyValue;	
			break;
	case 128: KeyValue="F17";
			return KeyValue;	
			break;
	default:
		return '';
		break;
	  }
 }
 
var KeyMapStr= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","ShowKeyMapValue")
var KeyMapArr=new Array();
var AddCtrlFlag=false,AddShiftFlag=false,AddAltFlag=false;
var UpdateCtrlFlag=false,UpdateShiftFlag=false,UpdateAltFlag=false;
var DeleteCtrlFlag=false,DeleteShiftFlag=false,DeleteAltFlag=false;
var HelpCtrlFlag=false,HelpShiftFlag=false,HelpAltFlag=false;
 
if (KeyMapStr!=""){
	KeyMapArr=KeyMapStr.split("^"); 
	if (KeyMapArr.length>0){
		if(KeyMapArr[0].indexOf("Ctrl")>= 0)   AddCtrlFlag=true
		if(KeyMapArr[0].indexOf("Shift")>= 0)  AddShiftFlag=true
		if(KeyMapArr[0].indexOf("Alt")>= 0)	   AddAltFlag=true
		
		if(KeyMapArr[1].indexOf("Ctrl")>= 0)   UpdateCtrlFlag=true
		if(KeyMapArr[1].indexOf("Shift")>= 0)  UpdateShiftFlag=true
		if(KeyMapArr[1].indexOf("Alt")>= 0)	   UpdateAltFlag=true
		
		if(KeyMapArr[2].indexOf("Ctrl")>= 0)   DeleteCtrlFlag=true
		if(KeyMapArr[2].indexOf("Shift")>= 0)  DeleteShiftFlag=true
		if(KeyMapArr[2].indexOf("Alt")>= 0)	   DeleteAltFlag=true
		
		if(KeyMapArr[3].indexOf("Ctrl")>= 0)   HelpCtrlFlag=true
		if(KeyMapArr[3].indexOf("Shift")>= 0)  HelpShiftFlag=true
		if(KeyMapArr[3].indexOf("Alt")>= 0)	   HelpAltFlag=true
	} 
}
 
	 
Ext.BDP.FunLib.Component.KeyMap = function(AddData,UpdateData,DelData,flag)
{  
 //if(window.ActiveXObject)//判断浏览器是否属于IE,其它浏览器不执行该方法，否则可能会报错
 //{ 
	
	var OneKeyUp=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","IfOneKeyMap");  
	if (OneKeyUp=="Y"){ 
	var keymap = new Ext.KeyMap(document, 
	[{  
				/****快捷键用shift A组合键， 用来增加功能。    ***/
		 	    key: KeyMapArr[0].substr(KeyMapArr[0].length-1) ,
			    ctrl:AddCtrlFlag, 
			    shift:AddShiftFlag,
			    alt:AddAltFlag,
			    stopEvent:true,
			    fn:function(e){
			    if (Ext.BDP.FunLib.Component.DisableFlag("add_btn")==false)
			    	{
			    		Ext.BDP.FunLib.StopDefault(e);
			    		AddData();
			    	}
			    	else{
			    		Ext.Msg.show({
			    						title:'提示',
										minWidth:280,
										msg:'添加功能被禁用,没法添加数据!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
			    					});
			    	}
			    }
			}, {    /****  快捷键用shift U组合键，用来修改功能。****/
			    key: KeyMapArr[1].substr(KeyMapArr[1].length-1), 
			    ctrl:UpdateCtrlFlag, 
			    shift:UpdateShiftFlag,
			    alt:UpdateAltFlag,
			    stopEvent:true,
			    fn:function(e){
			    if (Ext.BDP.FunLib.Component.DisableFlag("update_btn")==false)
			    	{
			    		Ext.BDP.FunLib.StopDefault(e);
			    		UpdateData();
			    	}
			    	else{
			    		Ext.Msg.show({
			    						title:'提示',
										minWidth:280,
										msg:'修改功能被禁用,没法修改数据!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
			    					});
			    	}
			    }
			}, { // 用来删除功能。****/
			    key:KeyMapArr[2].substr(KeyMapArr[2].length-1),
			    ctrl:DeleteCtrlFlag, 
			    shift:DeleteShiftFlag,
			    alt:DeleteAltFlag,
			    stopEvent:true,	 
			    fn:function(e){
			    if (Ext.BDP.FunLib.Component.DisableFlag("del_btn")==false)
			    {
			    	Ext.BDP.FunLib.StopDefault(e);
			    	DelData();
			    }
			    else{
			    	Ext.Msg.show({
			    					title:'提示',
									minWidth:280,
									msg:'删除功能被禁用,没法删除!',
									icon:Ext.Msg.WARNING,
									buttons:Ext.Msg.OK
		    					});
			    	}
			    }
			} ,{ /****快捷键用组合键，用来显示帮助信息。****/
			    key:KeyMapArr[3].substr(KeyMapArr[3].length-1), 
			    ctrl:HelpCtrlFlag, 
			    shift:HelpShiftFlag,
			    alt:HelpAltFlag,
			    stopEvent:true,
			    fn:function(e){
			    	Ext.BDP.FunLib.StopDefault(e);
			    	Ext.BDP.FunLib.Component.AlertHelpMsg();
			    }
			/*}, {
				key:Ext.EventObject.ENTER, *//**按钮转换功能，将enter键转换为tab键。当为button时不进行按键的转换**//*
			    stopEvent:true,
				fn:  function changeFocus()
				{
					var e=window.event||e;
					var element=e.srcElement||e.target;
					if(e.keyCode==13&&element.type!="button")
					{
						if(flag==1){
							e.keyCode=13;
						}else{
							getNextInput(element).focus();
						}
					}
				}*/
			}]
		);
		return keymap;
	} 
	else
	{
			var keymap = new Ext.KeyMap(document, 
			[{
			    key: Ext.EventObject.A, 
			    shift :true,  
				ctrl:true, 			
			    fn:function(e){
			    if (Ext.BDP.FunLib.Component.DisableFlag("add_btn")==false)
			    	{
			    		Ext.BDP.FunLib.StopDefault(e);
			    		AddData();
			    	}
			    	else{
			    		Ext.Msg.show({
			    						title:'提示',
										minWidth:280,
										msg:'添加功能被禁用,没法添加数据!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
			    					});
			    	}
			    }
			}, {
			    key:Ext.EventObject.U, 
			    shift :true,  
				ctrl:true, 
			    fn:function(e){
			    if (Ext.BDP.FunLib.Component.DisableFlag("update_btn")==false)
			    	{
			    		Ext.BDP.FunLib.StopDefault(e);
			    		UpdateData();
			    	}
			    	else{
			    		Ext.Msg.show({
			    						title:'提示',
										minWidth:280,
										msg:'修改功能被禁用,没法修改数据!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
			    					});
			    	}
			    }
			}, {
			    key:Ext.EventObject.D, 
			    shift :true,  
				ctrl:true, 
			    fn:function(e){
			    	if (Ext.BDP.FunLib.Component.DisableFlag("del_btn")==false)
			    	{
			    		Ext.BDP.FunLib.StopDefault(e);
			    		DelData();
			    	}
			    	else{
			    		Ext.Msg.show({
			    						title:'提示',
										minWidth:280,
										msg:'删除功能被禁用,没法删除!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
			    					});
			    	}
			    }
			}, {
			    key:Ext.EventObject.H, 
			    shift :true,  
				ctrl:true, 
			    fn:function(e)
			    {
			      Ext.BDP.FunLib.StopDefault(e);
			      Ext.BDP.FunLib.Component.AlertHelpMsg();
			    }
			/*}, {
				key:Ext.EventObject.ENTER,  
				fn:  function changeFocus()
				{
					var e=window.event||e;
					var element=e.srcElement||e.target;
					if(e.keyCode==13&&element.type!="button")
					{
						if(flag==1){
							e.keyCode=13;
						}else{
							getNextInput(element).focus();
						}
					}
				}*/
			}]
		);
	}
}
 
/**弹出帮助信息**/
//蔡昊哲  2012-12-4
Ext.BDP.FunLib.Component.AlertHelpMsg = function(){
	Ext.Msg.alert('帮助','<img src="'+Ext.BDP.FunLib.Path.URL_Img+'HelpMsg.png" width="300px" height="250px"/>');
} 


/**帮助信息tool**/
/**使用方法 在主Grid下添加tools:Ext.BDP.FunLib.Component.HelpMsg **/
//蔡昊哲  2012-12-4
Ext.BDP.FunLib.Component.HelpMsg = [{
        id:"help",
        handler:Ext.BDP.FunLib.Component.AlertHelpMsg
    }];
    
/**该数组用来存放对号标志信息**/	 
Ext.BDP.FunLib.Component.ValidResultSet = new Array(); 

/**数据验证成功显示对号的方法**/
/**使用方法 listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult} **/
//蔡昊哲  2013-1-11
Ext.BDP.FunLib.Component.ReturnValidResult = function(obj){ 
	var _dom=document.getElementById(obj.id+'-icon');
	if(_dom!=null)
	{	
		_dom.parentNode.removeChild(_dom);
		for(i in Ext.BDP.FunLib.Component.ValidResultSet) //遍历数组，数组中如果已有该控件ID则删除
		{ 
			if(Ext.BDP.FunLib.Component.ValidResultSet[i]==obj.id)
			{
				Ext.BDP.FunLib.Component.ValidResultSet.splice(i,1);
			}
		} 
	}
	if(obj.isValid()){ //当数据验证通过时要显示对号
		Ext.BDP.FunLib.Component.ValidResultSet[Ext.BDP.FunLib.Component.ValidResultSet.length]=obj.id; //新增对号ID到数组中
		var _parentNode = obj.el.dom.parentNode;
		var valid =  Ext.get(_parentNode).createChild({
	    	 tag : 'span',
	    	 id : obj.id+'-icon',
		     html : "<img  src ='"+Ext.BDP.FunLib.Path.URL_Icon+"accept.png' style='border: 0px' />"
		});
	}
}

/**FormPanel隐藏时清空所有对号 **/
/**使用方法 listeners : {'hide' : Ext.BDP.FunLib.Component.FromHideClearFlag();} **/
//蔡昊哲 2013-01-14
Ext.BDP.FunLib.Component.FromHideClearFlag = function(){ 
	for(i in Ext.BDP.FunLib.Component.ValidResultSet)  //遍历数组,逐个清空对号标志
	{ 
		var _dom=document.getElementById(Ext.BDP.FunLib.Component.ValidResultSet[i]+"-icon");
		if(_dom!=null)
		{	
			_dom.parentNode.removeChild(_dom);	
		}
	}
	Ext.BDP.FunLib.Component.ValidResultSet.length = 0;  //将数组清空	
}

/** grid浮动显示，当字段太长无法完全显示时，鼠标放在上面可以悬浮显示 */
/**使用方法 renderer: Ext.BDP.FunLib.Component.GirdTipShow **/
//蔡昊哲 2013-01-17
Ext.BDP.FunLib.Component.GirdTipShow = function (value, meta, rec, rowIdx, colIdx, ds){
	return '<span ext:qtitle="" ext:qtip="' + value + '">'+ value +'</span>';
}
Ext.BDP.FunLib.Component.TreeTipShow = function (value, meta, record, rowIdx, colIdx, ds){
	if ((meta.id.indexOf("L")<0)&&(meta.id.indexOf("H")<0)){
		return '<span ext:qtitle="" ext:qtip="' + value + '">'+ value +'</span>';
	}else{
		var val=value.split("#")[0];
		var count=value.split("#")[1];
		return '<span ext:qtitle="" ext:qtip="' + val + '">' + val + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+count+'</h6></span>';
	}
}
var GroupId1 = session['LOGON.GROUPID'];

Ext.BDP.FunLib.Session = function ()
{
	var mystr="";
	mystr+="^";									///IP
	mystr+=session['LOGON.USERID']+"^";         ///USERID
	mystr+=session['LOGON.CTLOCID']+"^";		///CTLOCID
	mystr+=session['LOGON.GROUPID']+"^";		///GROUPID
	mystr+="^";                                 ///HospitalID
	mystr+=session['LOGON.SITECODE']+"^";	    ///SITECODE
	mystr+="^"                                  ///context
	return mystr;
}

///陈莹 2017-02-28  根据系统配置 获取日期格式  
///2017-07-25 判断系统有没有定义日期格式  ///bug重现方式： 30/06/2017,将30改为3后，日期变为06/03/2017
 if (typeof(websys_DateFormat) == "undefined") {
	var BDPDateFormat=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetDateFormat");
 } else {
    var BDPDateFormat=websys_DateFormat
}
     
//var TodayDate=(new Date()).format(BDPDateFormat);
/** 当在datefield下输入t时,默认显示当天日期(格式为系统配置--配置管理里的格式 Y-m-d或j/n/Y) ,输入+/- N 天时，显示对应的日期 */
/**使用方法 listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }} **/	
/**备注 1.要增加 enableKeyEvents : true,  keyup事件才可以启用 **/
//陈莹  2017-02-28
Ext.BDP.FunLib.Component.GetCurrentDate = function(field, e){	
	var format=BDPDateFormat
	
	if(field.el.dom.value!="t" & field.el.dom.value!="T" & field.el.dom.value.indexOf('+')<0 & field.el.dom.value.indexOf('-')<0){  //排除三种情况不监控返回对应日期
		
		return ;
	}
	else
	{
		var flag = 0;
		var curDateTime;
		var d = new Date();
		
		if((field.el.dom.value=="t")||(field.el.dom.value=="T")){               	//当输入t/T时显示当前日期
			//alert("1")
		}
		
		if(format=="Y-m-d")
 		{
 			var DisplayDate =field.el.dom.value.split("-");
 			if (DisplayDate.length>3)
 			{
	 			if((DisplayDate[3]!="")&(!isNaN(DisplayDate[3])))
	 			{
	 				if ((!isNaN(DisplayDate[0]))&(!isNaN(DisplayDate[1]))&(!isNaN(DisplayDate[2])))
	 				{
	 					var N = parseInt(DisplayDate[3],10);
						d.setFullYear(parseInt(DisplayDate[0],10));
				 		d.setMonth(parseInt(DisplayDate[1],10)-1);
				 		d.setDate(parseInt(DisplayDate[2],10) - N);
	 				}
	 				else
	 				{
	 					flag = 1;
	 				}
	 			}
	 			else
				{
					flag = 1;
				}
 			}
 			else if(DisplayDate.length=3)
 			{
 				if((field.el.dom.value!="t")&(field.el.dom.value!="T"))
 				{  
 					if ((!isNaN(DisplayDate[0]))&(!isNaN(DisplayDate[1]))&(!isNaN(DisplayDate[2]))&(DisplayDate[2]!=0)&(DisplayDate[2]!=""))
	 				{
	 					d.setFullYear(parseInt(DisplayDate[0],10));
				 		d.setMonth(parseInt(DisplayDate[1],10)-1);
				 		d.setDate(parseInt(DisplayDate[2],10));
	 				}
	 				else
	 				{
	 					flag = 1;
	 				}
				}
 			}
 			
 			if(field.el.dom.value.indexOf('+')>=0)    //当包含 + 号时
			{
				var DisplayDate =field.el.dom.value.split("+");
				if((DisplayDate[1]!="")&(!isNaN(DisplayDate[1])))				//判断+号后面日期不等于空
				{
					
			 		 	var N = parseInt(DisplayDate[1],10)
						var Detail = DisplayDate[0].split("-");
						if ((!isNaN(Detail[0]))&(!isNaN(Detail[1]))&(!isNaN(Detail[2])))
		 				{
							d.setFullYear(parseInt(Detail[0],10));
						 	d.setMonth(parseInt(Detail[1],10)-1);
						 	d.setDate(parseInt(Detail[2],10) + N);
						 	flag = 0;
		 				}
		 				else
		 				{
		 					flag = 1;
		 				}
	 				
				}
				else
				{
					flag = 1;
				}
				
			}
 			
 		}
 		
 		if(format=="j/n/Y")
 		{
 			if(field.el.dom.value.indexOf('+')>=0)    //当包含 + 号时
			{
				var DisplayDate =field.el.dom.value.split("+");
				if((DisplayDate[1]!="")&(!isNaN(DisplayDate[1])))				//判断+号后面日期不等于空
				{	
		 			var N = parseInt(DisplayDate[1],10)
					var Detail = DisplayDate[0].split("/");
					if ((!isNaN(Detail[0]))&(!isNaN(Detail[1]))&(!isNaN(Detail[2])))
		 			{
						d.setFullYear(parseInt(Detail[2],10));
					 	d.setMonth(parseInt(Detail[1],10)-1);
					 	d.setDate(parseInt(Detail[0],10) + N);
		 			}
		 			else
					{
						flag = 1;
					}
				}
				else
				{
					flag = 1;
				}
			}
			
			if(field.el.dom.value.indexOf('-')>=0)    //当包含 - 号时
			{	
				var DisplayDate =field.el.dom.value.split("-");
				if((DisplayDate[1]!="")&(!isNaN(DisplayDate[1])))				//判断-号后面日期不等于空
				{
					var N = parseInt(DisplayDate[1],10)
					var Detail = DisplayDate[0].split("/");
					if ((!isNaN(Detail[0]))&(!isNaN(Detail[1]))&(!isNaN(Detail[2])))
		 			{
						d.setFullYear(parseInt(Detail[2],10));
					 	d.setMonth(parseInt(Detail[1],10)-1);
					 	d.setDate(parseInt(Detail[0],10) - N);
					}
		 			else
					{
						flag = 1;
					}
				}
				else
				{
					flag = 1;
				}
						
			}
 			
 		}
		 		
		
 		
 		if(format=="Y/m/d") ///2020-10-14 项目上格式还是原来的年/月/日格式。 需要设置BDPDateFormat=“Y/m/d"
 		{
 			if(field.el.dom.value.indexOf('+')>=0)    //当包含 + 号时
			{
				var DisplayDate =field.el.dom.value.split("+");
				if((DisplayDate[1]!="")&(!isNaN(DisplayDate[1])))				//判断+号后面日期不等于空
				{	
		 			var N = parseInt(DisplayDate[1],10)
					var Detail = DisplayDate[0].split("/");
					if ((!isNaN(Detail[0]))&(!isNaN(Detail[1]))&(!isNaN(Detail[2])))
		 			{
						d.setFullYear(parseInt(Detail[0],10));
					 	d.setMonth(parseInt(Detail[1],10)-1);
					 	d.setDate(parseInt(Detail[2],10) + N);
		 			}
		 			else
					{
						flag = 1;
					}
				}
				else
				{
					flag = 1;
				}
			}
			
			if(field.el.dom.value.indexOf('-')>=0)    //当包含 - 号时
			{	
				var DisplayDate =field.el.dom.value.split("-");
				if((DisplayDate[1]!="")&(!isNaN(DisplayDate[1])))				//判断-号后面日期不等于空
				{
					var N = parseInt(DisplayDate[1],10)
					var Detail = DisplayDate[0].split("/");
					if ((!isNaN(Detail[0]))&(!isNaN(Detail[1]))&(!isNaN(Detail[2])))
		 			{
						d.setFullYear(parseInt(Detail[0],10));
					 	d.setMonth(parseInt(Detail[1],10)-1);
					 	d.setDate(parseInt(Detail[2],10) - N);
					}
		 			else
					{
						flag = 1;
					}
				}
				else
				{
					flag = 1;
				}
						
			}
 			
 		}
		 //以下为返回所得的日期
		 var year = d.getFullYear(); 
		 var month = d.getMonth() + 1; 
		 var date = d.getDate(); 
		
		if ((!isNaN(year))&(!isNaN(month))&(month!=0)&(!isNaN(date))&(date!=0))
		{ 
		
			 if(format=="Y-m-d")
			 {
			 	curDateTime = ""; 
			 	if (month > 9) curDateTime = year + "-" + month; 
			    else curDateTime = year + "-0" + month; 
			    if (date > 9) curDateTime = curDateTime + "-" +  date; 
			    else curDateTime = curDateTime + "-0" + date; 
			 }
			 if(format=="j/n/Y")
			 {
			 	curDateTime="";
			 	curDateTime = date+"/"+  month+ "/" + year; 
			 }
			 if(format=="Y/m/d") //2020-10-14
			 {
			 	curDateTime="";
			 	curDateTime = year+"/"+  month+ "/" +date ; 
			 }
			 if(flag == 0)
			 {
			 	// field.el.dom.value = curDateTime; 
				setTimeout(field.el.dom.value = curDateTime,300); // 解决IE下 显示日期不对 含有t的问题				
			 }
		 }
		 
	}
}

/** 当在datefield下输入t时,默认显示当天日期 ,输入+/- N 天时，显示对应的日期 */
/**使用方法 listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }} **/	
/**备注 1.要增加 enableKeyEvents : true,  keyup事件才可以启用 **/
/**备注 2.如果想返回格式为 MM/DD/YYYY，需要再加个参数"M", Ext.BDP.FunLib.Component.GetCurrentDate(field,e,"M")  **/
//蔡昊哲 2013-5-14  
//lastUpdate 2013-8-14
/*
Ext.BDP.FunLib.Component.GetCurrentDate = function(field, e , format){	
	if(field.el.dom.value!="t" && field.el.dom.value!="T" && field.el.dom.value.indexOf('+')<0 && field.el.dom.value.indexOf('-')<0){  //排除三种情况不监控返回对应日期
		return;
	}
	else
	{
		var flag = 0;
		var curDateTime = "";
		
		var d = new Date();
		if(field.el.dom.value=="t"){               	//当输入t时显示当前日期
			//alert("1")
		}
		
		if(field.el.dom.value.indexOf('+')>=0)    //当包含 + 号时
		{
			var DisplayDate =field.el.dom.value.split("+");
			if(DisplayDate[1]!="")				//判断+号后面日期不等于空
			{		
			 	//var DisplayDate =field.el.dom.value.split("+");
			 	if(!isNaN(DisplayDate[1])){
					var N = parseInt(DisplayDate[1],10)
					var Detail = DisplayDate[0].split("/");
					d.setFullYear(parseInt(Detail[0],10));
				 	d.setMonth(parseInt(Detail[1],10)-1);
				 	d.setDate(parseInt(Detail[2],10) + N);
				}
				else{
					flag = 1;
				}
			 	
			}
			else
			{
				flag = 1;
			}
		}
		
		if(field.el.dom.value.indexOf('-')>=0)    //当包含 - 号时
		{
			var DisplayDate =field.el.dom.value.split("-");
			if(DisplayDate[1]!="")				//判断-号后面日期不等于空
			{		
			 	//var DisplayDate =field.el.dom.value.split("-");
			 	if(!isNaN(DisplayDate[1])){
					var N = parseInt(DisplayDate[1],10)
					var Detail = DisplayDate[0].split("/");
					d.setFullYear(parseInt(Detail[0],10));
				 	d.setMonth(parseInt(Detail[1],10)-1);
				 	d.setDate(parseInt(Detail[2],10) - N);
				}
				else{
					flag = 1;
				}			 	
			}
			else
			{
				flag = 1;
			}
		}
		
		//以下为返回所得的日期
		 var year = d.getFullYear(); 
		 var month = d.getMonth() + 1; 
		 var date = d.getDate(); 
		 if(format!="M")
		 {
		 	curDateTime = year; 
		 	if (month > 9) 
		       curDateTime = curDateTime + "/" + month; 
		    else 
		       curDateTime = curDateTime + "/0" + month; 
		    if (date > 9) 
		       curDateTime = curDateTime + "/" +  date; 
		    else 
		       curDateTime = curDateTime + "/0" + date; 
		 }
		 else
		 {
		 	if (month > 9) 
		       curDateTime = curDateTime + month; 
		    else 
		       curDateTime = curDateTime + month; 
		    if (date > 9) 
		       curDateTime = curDateTime + "/" +  date; 
		    else 
		       curDateTime = curDateTime + "/0" + date;
		       
		    curDateTime = curDateTime + "/" + year; 
		 }
		 if(flag == 0)
		 {
		 	field.el.dom.value = curDateTime;  
		 }
	}
}
*/
/** 只读控件的遮罩样式 */
/** 用法举例 style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName')),*/
//蔡昊哲 2013-9-10 
Ext.BDP.FunLib.ReadonlyStyle  = function(flag)
{
	var style;
	if(flag==true)
	{
		style = 'background:#E6E6E6'
	}
	else style =''
	return style;
}

/** chenkbox只读状态下不允许点击 */
Ext.override(Ext.form.Checkbox, {
onClick: function () {
if (this.readOnly === true) this.el.dom.checked = this.checked;
//Ext.form.Checkbox.superclass.setValue.apply(this, arguments);
if(this.el.dom.checked != this.checked){
            this.setValue(this.el.dom.checked);
        }
}
});

/**快捷键KeyMap的封装方法**/
/**参数解释 AddData: 新增,UpdateData:修改，DelData：删除**/
/**使用方法   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器，否则可能会报错
    {
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData,Refresh);
    } 
   参数为自己JS中对应的方法名 **/
/**参数格式 "{menuLocClassify:{iconCls:'icon-AdmType',handler:'LocClassifyWinEdit',text:'科室分类'}}";**/
Ext.BDP.FunLib.Component.RightMenu = function(grid,DataJson){	
		if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  		{
  			grid.addListener('RowContextMenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont',
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
    		{
	            iconCls :'icon-add',
	            handler: AddData,
	            id:'menuAddData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
	            text: '添加'
	        },{
	            iconCls :'icon-Update',
	            handler: UpdateData,
	             id:'menuUpdateData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'),
	            text: '修改'
	        },{
	            iconCls :'icon-stop',
	            handler: DelData,
	             id:'menuDelData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDelData'),
	            text: '删除'
	         }]     	
		}); 
		
             var jsonObj = Ext.util.JSON.decode(DataJson);   //解析JSON，存入对象变量jsonObj中
		     for(var n in jsonObj)                                    //遍历JsonObj，摘取所需要的信息存到对应数组中
		     {
		     	var Menu = {
		     		id: jsonObj[n],
		     		iconCls : jsonObj[n].iconCls,
		     		handler : jsonObj[n].handler,
		     		text : jsonObj[n].text,
		     		disabled : Ext.BDP.FunLib.Component.DisableFlag(jsonObj[n])
		     	}
		     	 rightClick.add(Menu);
		     }
		    
	          	//alert(n+','+jsonObj[n].Disable +','+jsonObj[n].Hidden);  //弹出解析后的数据，用于测试	     	
	      	 }
      	 
          
		
		function rightClickFn(grid,rowindex,e){
    	 e.preventDefault();
    	 var currRecord = false; 
   		 var currRowindex = false; 
   		 var currGrid = false; 
         if (rowindex < 0) { 
         	return; 
  		 } 
	     grid.getSelectionModel().selectRow(rowindex); 
	     currRowIndex = rowindex; 
	     currRecord = grid.getStore().getAt(rowindex); 
	     currGrid = grid; 
	     rightClick.showAt(e.getXY()); 
        }
    }

    
    /*Ext.BDP.FunLib.Component.test  = function(tb,DataJson){
    	
    	grid.addListener('RowContextMenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont',
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
    		{
	            iconCls :'icon-add',
	            handler: AddData,
	            id:'menuAddData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
	            text: '添加'
	        },{
	            iconCls :'icon-Update',
	            handler: UpdateData,
	             id:'menuUpdateData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'),
	            text: '修改'
	        },{
	            iconCls :'icon-stop',
	            handler: DelData,
	             id:'menuDelData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDelData'),
	            text: '删除'
	         }]     	
		}); 
		
    	alert("test");
    	Ext.getCmp(tb).items
    	var Mid = "Menu" + Ext.getCmp('tb').items.items[8].id
    	var MiconCls = Ext.getCmp('tb').items.items[8].iconCls
    	var Mtext = Ext.getCmp('tb').items.items[8].test
    	var Mhandler = Ext.getCmp('tb').items.items[8].handler
    	var Menu = {
     		id: Mid,
     		iconCls : MiconCls,
     		handler : Mhandler,
     		text : Mtext,
     		disabled : Ext.BDP.FunLib.Component.DisableFlag(Mid)
		}
		RightClick.add(Menu);
		
    }*/
    
    
	 Ext.BDP.FunLib.getParam = function(name){
        var search = document.location.search;
        var pattern = new RegExp("[?&]"+name+"\=([^&]+)", "g");
        var matcher = pattern.exec(search);
        var items = null;
        if(null != matcher){
                try{
                        items = decodeURIComponent(decodeURIComponent(matcher[1]));
                }catch(e){
                        try{
                                items = decodeURIComponent(matcher[1]);
                        }catch(e){
                                items = matcher[1];
                        }
                }
        }
        return items;
};

/**用于删除后正确返回页码**/
Ext.BDP.FunLib.DelForTruePage = function(grid,pagesize){
	var startIndex = grid.getBottomToolbar().cursor;
	var totalnum=grid.getStore().getTotalCount();
	if(totalnum==1){    //修改添加后只有一条，返回第一页
		var startIndex=0
	}
	else if((totalnum-1)%pagesize==0)//最后一页只有一条
	{
		var pagenum=grid.getStore().getCount();
		if (pagenum==1){ startIndex=startIndex-pagesize;}  //最后一页的时候
	//不是最后一页则还停留在这一页
	}
	grid.getStore().load({
		params : {
			start : startIndex,
			limit : pagesize  
			}	
	});	
};


/** 修改成功后，页面不刷新，只修改变动数据**/
/** chz -> 2014/3/5 **/
/** 使用方法 Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid) **/
/** 参数含义 
 *  grid： 当前gridpanel名  如 grid  
 *  uel： 获取对象的方法    如 ACTION_URL 
 *  rowid: 修改数据的rowid 如 myrowid **/
Ext.BDP.FunLib.ReturnDataForUpdate = function(grid,url,rowid){
	Ext.Ajax.request({
		method : 'POST',
		url:url + "&" + rowid,
		success: function(response,options){
			var respText = Ext.util.JSON.decode(response.responseText); 			
			var nub = Ext.getCmp(grid).getSelectionModel().lastActive;   //获取选中行行号
			var obj = Ext.getCmp(grid).getSelectionModel().getSelections()[0].data;  //获取选择行列名对象组
			for (var code in obj){ 											// 遍历行列名对象组 
				Ext.getCmp(grid).getStore().getAt(nub).set(code,eval("respText.data[0]."+code));
			}
		}
	});  
}
 
/**
 * PagingToolbarResizer plugin for Ext PagingToolbar
 * Contains a combobox where user can choose the pagesize dynamically
 * @author    sunfengchao 自定义分页工具条
 * @date      2014-2-18
 * @class Ext.BDP.FunLib.PagingToolbarResizer
 * @extends Ext.Component
 */
Ext.BDP.FunLib.PagingToolbarResizer = Ext.extend(Object, {

  options: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500,1000],
  
  mode: 'local',
  
  displayText: $g('每页显示记录'),

  constructor: function(config){
    Ext.apply(this, config);
    Ext.BDP.FunLib.PagingToolbarResizer.superclass.constructor.call(this, config);
  },

  init : function(pagingToolbar) {
 
    var comboStore = this.options;
   
    var combo = new Ext.form.ComboBox({
      typeAhead: false,
      triggerAction: 'all',
      forceSelection: true,
      selectOnFocus:true,
      lazyRender:true,
      editable: false,
      mode: this.mode,
      value: pagingToolbar.pageSize,
      width:50,
      store: comboStore,
      listeners: {
          select: function(combo, value, i){
          pagingToolbar.pageSize = comboStore[i];
          pagingToolbar.doLoad(Math.floor(pagingToolbar.cursor/pagingToolbar.pageSize)*pagingToolbar.pageSize);
        }
      }
    });

    var index = 0;
    
    if (this.prependCombo){
     index = pagingToolbar.items.indexOf(pagingToolbar.first);
     index--;
    } else{
     index = pagingToolbar.items.indexOf(pagingToolbar.refresh);
        pagingToolbar.insert(++index,'-');
    }
    
    pagingToolbar.insert(++index, this.displayText);
    pagingToolbar.insert(++index, combo);
    
    if (this.prependCombo){
      pagingToolbar.insert(++index,'-');
    }
    
    //destroy combobox before destroying the paging toolbar
    pagingToolbar.on({
      beforedestroy: function(){
     combo.destroy();
      }
    });
  }
});

/************************************ 翻译按钮开始************************************/			
//谷雪萍  2015-5-14
Ext.BDP.FunLib.TranslationBtn = new Ext.Toolbar.Button({
				text : $g('翻译'),
				tooltip : $g('翻译'),
				id:'translation_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('translation_btn'),
				iconCls : 'icon-edit',
				handler : function OpenTransWin() {
					if(Ext.BDP.FunLib.SelectRowId!=""){
						 var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPTranslation&selectrow="+Ext.BDP.FunLib.SelectRowId+"&tableName="+Ext.BDP.FunLib.TableName;
						 if ('undefined'!==typeof websys_getMWToken)
				        {
							link += "&MWToken="+websys_getMWToken() //增加token
						}
						 var TransWin = new Ext.Window({
								width:650,
					            height:400,
					            id:'TransWin',
					            title:'',
							   	layout : 'fit',
								plain : true,// true则主体背景透明
								modal : true,
								frame : true,
							    autoScroll : false,
								collapsible : true,
								hideCollapseTool : true,
								titleCollapse : true,
								constrain : true,
								closeAction : 'close',
								html : '<iframe src=" '+link+' " width="100%" height="100%"></iframe>'
							});
						//TransWin.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';						
						TransWin.setTitle($g('数据翻译'));
						TransWin.setIconClass('icon-edit');
						TransWin.show();				
					}else{
						Ext.Msg.show({
									title : $g('提示'),
									msg : $g('请选择需要翻译的行！'),
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
/************************************ 翻译按钮结束************************************/			
/************************************排序按钮***************************************************/
Ext.BDP.FunLib.SortBtn = new Ext.Toolbar.Button({
		text : '排序',
		tooltip : '排序',
		id:'sort_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sort_btn'),
		iconCls : 'icon-arrowrefresh',
		handler : function OpenSortWin() {
			 var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPSort&tableName="+Ext.BDP.FunLib.SortTableName;
			 if ('undefined'!==typeof websys_getMWToken)
	        {
				link += "&MWToken="+websys_getMWToken() //增加token
			}
			 var SortWin = new Ext.Window({
					width:950,
		            height:Math.min(Ext.getBody().getHeight()-30,800),
		            id:'SortWin',
		            title:'',
				   	layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					frame : true,
				    autoScroll : false,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					constrain : true,
					closeAction : 'close',
					html : '<iframe src=" '+link+' " width="100%" height="100%"></iframe>'
				});
			//SortWin.html='<iframe id="iframsort" src=" '+link+' " width="100%" height="100%"></iframe>';						
			SortWin.setTitle('排序(排序类型为空时，可手动录入保存)');
			SortWin.setIconClass('icon-arrowrefresh');
			SortWin.show();		
		}
	});	
	
/// ////////////////////国家/地区标准编码页面 ////////////////////////////////////////////////////////////////////////
      var menuName=""
      var CMBOXURL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassQuery=GetDataForCmb1&menuName="+menuName;
	  var NationalCodeStore=new Ext.data.Store({
         	proxy : new Ext.data.HttpProxy({ url : CMBOXURL}),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'BDPDomainRowId', 'BDPDomainExpression'])
      });
     var showStr=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","ShowGrid"); 
     var FormReadOnlyArr=[];
     FormReadOnlyArr=showStr.split("^");  
	 
     var BDPDomainDescFlag=FormReadOnlyArr[0];
	 var BDPDomainDescFlag2=FormReadOnlyArr[1];
     if ((BDPDomainDescFlag=="true")||(BDPDomainDescFlag2=="true")){
        BDPDomainDescFlag=false;
     }
     else{
         BDPDomainDescFlag=true;
     }
     var BDPDomainValueFlag= FormReadOnlyArr[2];
     if (BDPDomainValueFlag=="true"){
        BDPDomainValueFlag=false;
     }
     else{
         BDPDomainValueFlag=true;
     }
     var BDPDomainValueF1Flag= FormReadOnlyArr[3];
     if (BDPDomainValueF1Flag=="true"){
        BDPDomainValueF1Flag=false;
     }
     else{
         BDPDomainValueF1Flag=true;
     }
	  Ext.BDP.FunLib.WinForm = new Ext.FormPanel({
				id : 'form-save2',
				labelAlign : 'right',
				split : true,
				frame : true,
				labelWidth:120,
				defaults : {
					border : false   
				},
				title:'国家/地区标准编码',
				frame : true,  		
				defaults : {
					anchor : '90%',
					border : false
				},
				items : [{
							id:'BDPDomainRowId',
							xtype:'textfield',
							fieldLabel : 'BDPDomainRowId',
							name : 'BDPDomainRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							xtype:'combo',
					        loadByIdParam:'rowid',
					        fieldLabel : '国家/地区标准编码名称',
					        name : 'BDPInternalDesc' ,
					        id:'BDPDomainDescF',
							readOnly :BDPDomainDescFlag ,
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainDescF')),
					        store :NationalCodeStore,
						    queryParam : 'desc',
						    triggerAction : 'all',
						    forceSelection : true,
						    selectOnFocus : false,
						    minChars : 0,
						    listWidth : 250,
						    valueField : 'BDPDomainRowId',
						    displayField : 'BDPDomainExpression',
						    hiddenName : 'BDPDomainDesc', 
						    pageSize :10,
						    enableKeyEvents : true,
							listeners:{
								'keyup':function(){ //alert(Ext.getCmp('BDPDomainDescF').getRawValue())
									 if (Ext.getCmp('BDPDomainDescF').getRawValue()==""){
									 	Ext.getCmp('BDPStandardDomainDRF').setValue('')
									 	Ext.getCmp('BDPStandardDomainValueF').setValue('');
									 }
								},
								'beforequery':function(){
									 menuName=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","GetMenuName") ; 
           							 var CMBOXURL =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassQuery=GetDataForCmb1&menuName="+menuName  
           						     NationalCodeStore.proxy = new Ext.data.HttpProxy({url:CMBOXURL}); 
								},
						     	'select':function(){
						     	 	var id=Ext.getCmp('BDPDomainDescF').getValue();
						     		var BDPStandardDomainDRValue=tkMakeServerCall("web.DHCBL.CT.BDPNationalDataDomain","FindDataValue",id); 
						     		var arr=[];
						     		var arr2=[];
						     		arr=BDPStandardDomainDRValue.split("^"); 
						     		arr2=arr[0].split("#"); 
	    							Ext.getCmp('BDPStandardDomainDRF').setValue(arr2[0]);
	    							Ext.getCmp('BDPStandardDomainValueF').setValue(arr2[1]);
	    							Ext.getCmp('BDPDomainDescF').setValue(arr[1]);  
						     	}
						     } 
						}, {
							fieldLabel : '国家/地区标准编码',
							xtype:'displayfield',
							id:'BDPStandardDomainDRF',
							name : 'BDPInternalCode',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainDRF'))
						}, {
							fieldLabel:'国家/地区标准编码值',
							xtype:'displayfield',
							id:'BDPStandardDomainValueF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainValueF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainValueF')),
							name : 'BDPStandardDomainValue'
						},{
							fieldLabel : '医院标准编码',
							xtype:'textfield',
							id:'BDPDomainValueF',
							readOnly :BDPDomainValueFlag , // Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF')),
							name : 'BDPHospNationalCode'
						},{
							fieldLabel : '医院标准编码名称',
							xtype:'textfield',
							id:'BDPDomainValueF1',
							readOnly : BDPDomainValueF1Flag, //Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF1')),
							name : 'BDPHospNationalDesc'
						}]	
	});	
 
	/// 添加修改操作时的保存方法
	Ext.BDP.NationalCodeModFun=function(TableName,DataReference){  
		var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
		if (ShowOrNot=="Y"){
			var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);   
			if (flag==1){
				var InternalCode=Ext.getCmp('BDPStandardDomainDRF').getValue();  
				var InternalDesc=Ext.getCmp('BDPDomainDescF').getRawValue();   
				var HospNationalCode=Ext.getCmp('BDPDomainValueF').getValue();
				var HospNationalDesc=Ext.getCmp('BDPDomainValueF1').getValue();
				var InternalValue=Ext.getCmp('BDPStandardDomainValueF').getValue();
				var ID=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","GetRowIdByReference",TableName,DataReference) 
				
				if((InternalCode=="")&&(InternalDesc=="")&&(InternalValue=="")&&(HospNationalCode=="")&&(HospNationalDesc=="")&&(ID==""))
				{  
					return false;
				}
				else
				{
				  var NationStr=InternalCode+"^"+InternalDesc+"^"+HospNationalCode+"^"+HospNationalDesc+"^"+TableName+"^"+DataReference+"^"+ID+"^"+InternalValue
				  Ext.Ajax.request({
		                url : "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPStandardCode&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPStandardCode",
		                params : {listData : NationStr},
		                failure : function(result, request) {
		                	Ext.Msg.show({
										title:'提示',
										minWidth:240,
										msg:'请检查网络连接!',
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
		                },
		                success : function(result, action) {
		                	var jsonData = Ext.util.JSON.decode(result.responseText);
							if(jsonData.success=='true') {
								
		                    }else{
								  Ext.Msg.show({
										title:'提示',
										minWidth:240,
										msg:"保存国家/地区标准编码失败!错误信息："+jsonData.errorinfo,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});  
			                    }
			                } 
			           });
					}
				}
		 	 }
		}
		
//// 打开form时的加载数据
	Ext.BDP.OpenNationalCodeFun=function(TableName,DataReference){
		var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
		if (ShowOrNot=="Y"){
		var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);  
		if (flag==1)
		{
			var NationalStr=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","OpenData",TableName,DataReference)
			if (NationalStr!=null){
				var arr=new Array();
				arr=NationalStr.split("^"); 
				Ext.getCmp('BDPStandardDomainDRF').setValue(arr[0]); // 国家/地区编码
				Ext.getCmp('BDPDomainDescF').setValue(arr[1]); 
				Ext.getCmp('BDPDomainValueF').setValue(arr[2]); 
				Ext.getCmp('BDPDomainValueF1').setValue(arr[3]); 
				Ext.getCmp('BDPStandardDomainValueF').setValue(arr[4]); 
		  	}
		  }
		  else{
		  		return;
		  }
		}
	}
/// 重置功能  国家/地区编码
	Ext.BDP.ResetFormFun=function(TableName){
		var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
		if (ShowOrNot=="Y"){
			var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);   
			if (flag==1){
				Ext.getCmp('BDPStandardDomainDRF').setValue(''); 
				Ext.getCmp('BDPDomainDescF').setValue(''); 
				Ext.getCmp('BDPDomainValueF').setValue(''); 
				Ext.getCmp('BDPDomainValueF1').setValue(''); 
				Ext.getCmp('BDPStandardDomainValueF').setValue('');
			}
		}
	}
//// 删除功能 
	Ext.BDP.DeleteFormFun=function(TableName,DataReference){
		var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
		if (ShowOrNot=="Y"){
			var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);   
			if (flag==1){
		  		Ext.Ajax.request({
				  url : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPStandardCode&pClassMethod=DeleteNationalCode",
				  method : 'POST',
				  params : {
			       	 	'tableName': TableName,
			        	'dataReference':DataReference
					},
					callback : function(options, success, response) {
					 if (success) {
						var jsonData = Ext.util.JSON.decode(response.responseText); 
						if (jsonData.success == "false"){
							Ext.Msg.alert("提示","删除标准数据编码失败!")
						}
					}
				}
			}); 
		}
	}
}
 /// 动态增加国家/地区标准编码grid 里store 的 reader 列
	Ext.BDP.AddReaderFieldFun=function(ds,fields,tableName){
		var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
		if (ShowOrNot=="Y"){
			var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",tableName);    
	 		if (flag==1){ 
	 			var showStr=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","ShowGrid"); 
				var arr=new Array();
				arr=showStr.split("^"); 
		     	var SCfield =[ 
		     	 	{name:'BDPInternalCode',mapping:'BDPInternalCode',type:'string'},
		     	 	{name:'BDPInternalDesc',mapping:'BDPInternalDesc',type:'string'},
		     	 	{name:'BDPHospNationalCode',mapping:'BDPHospNationalCode',type:'string'},
		     	 	{name:'BDPHospNationalDesc',mapping:'BDPHospNationalDesc',type:'string'}
		    	];  
	    		for (var i=0;i<SCfield.length;i++){
	 				 if (arr[i]=="true"){
	  						fields.push(SCfield[i]);
	 			 	}
				}
				var reader =  new Ext.data.JsonReader({
	    			totalProperty: 'total',
	    			root: 'data',
	    			successProperty :'success'
				},
				fields
			);
			ds.reader = reader;
	     }
	  } 
	}
	
/// 动态增加国家/地区标准数据里的grid列
	Ext.BDP.AddColumnFun=function(grid,tableName,cm){
		var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");  
		if (ShowOrNot=="Y")
		{
			var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",tableName);  
	 		if (flag==1){
				var ds=grid.getStore();
				var showStr=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","ShowGrid"); 
				var arr=new Array();
				arr=showStr.split("^"); 
        		var record=	[{
        					 header:'国家/地区标准编码',
							 width:110,
							 sortable:true,
					         dataIndex:'BDPInternalCode' 
					},{
							 header:'国家/地区标准编码名称',
							 width:110,
							 sortable:true,
					         dataIndex:'BDPInternalDesc' 
					}, { 	
						 	 header:'医院标准编码',
							 width:110,
							 sortable:true,
					         dataIndex:'BDPHospNationalCode' 
					},{
					         header:'医院标准编码名称',
							 width:110,
							 sortable:true,
					         dataIndex:'BDPHospNationalDesc' 
					}]
	 		 		for (var i=0;i<arr.length;i++)
	 		 		{  
 		 				if (arr[i]=="true")
 		 				{ 
 		 					cm.push(record[i])
 		 				}
 					} 
 					var column = new Ext.grid.ColumnModel(cm);
	 			}
			} 
		}
/// 整合tabpanel
	 Ext.BDP.AddTabpanelFun=function(tabs,tableName){
	 	var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
		if (ShowOrNot=="Y"){
	  	var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",tableName);  
		if (flag==1){
 		 tabs.add(Ext.BDP.FunLib.WinForm);
 		 tabs.on('tabchange', function() {
 		 		Ext.Ajax.request({  
	                	url : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPStandardCode&pClassMethod=SaveMenuName",
	               	 	params : {menuName : tableName} 
	            	});
 			 }); 
		 }
	}
 }
  
 
/****************************************************************************************/
//bootstrap版基础数据平台换肤
      var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        if (window.ActiveXObject)
            Sys.ie = ua.match(/msie ([\d.]+)/)[1]
        //以下进行测试
        if((!Sys.ie)||(Sys.ie=='11.0')){
	        //Ext.util.CSS.swapStyleSheet('theme', '../scripts/bdp/Framework/assets/css/xtheme-silverCherry.css');
	        
        }
        
 ///用于保存用户操作记录
///  2015-9-21
//// Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
//// Ext.BDP.FunLib.ShowUserHabit(grid,"User.CTCity");       
Ext.BDP.FunLib.ShowUserHabit = function(grid,tablename){
	///用户习惯展示——谷雪萍
	var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabit","ShowUserHabit",session['LOGON.USERID'],tablename);
	if (result!="")
	{
		var str= result.split(','); 
		for(var i=0;i<str.length;i++){
			var info=str[i].split('^');
			if(info[0]=="move"){ 
				try{
					grid.getColumnModel().moveColumn(info[1], info[2]);
				} 
				catch(e){}
			}
			if(info[0]=="hidden"){
				if(info[2]=="false"){
					info[2]=false
				}
				if(info[2]=="true"){
					info[2]=true
				}
				try{
					grid.getColumnModel().setHidden(info[1], info[2]);
				}
				catch(e){}
			}
		}
	}
	///用户习惯保存——陈莹
	function columnmoved1(cm,oldIndex,newIndex){		
		var index="";
		if (oldIndex!=newIndex)
		{
			var index="move"+"^"+oldIndex+"^"+newIndex;
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabit","SaveData",session['LOGON.USERID'],tablename,index);
		}
  	}
  	
  	function hiddenchange1(cm,columnIndex,hidden){
  		var index="hidden"+"^"+columnIndex+"^"+hidden;
  		var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabit","SaveData",session['LOGON.USERID'],tablename,index);			
 	}
 	grid.getColumnModel().addListener("columnmoved",columnmoved1);
 	grid.getColumnModel().addListener("hiddenchange",hiddenchange1);
}
    

   /** GridPanel数据超长，自动换行功能  蔡昊哲 2016-1-25**/
 document.write('<style type="text/css"> .x-grid3-cell-text-visible .x-grid3-cell-inner{overflow:visible;padding:3px 3px 3px 5px;white-space:normal;}  </style>');
 Ext.BDP.FunLib.Newline = function(grid){	
 	grid.store.on('load', function()
    {
          grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
          x.addClass('x-grid3-cell-text-visible');
      });
 	});
 }
 ////////////////////////////////日志功能  开始//////////////////////////////////////////////////////////
 
 //////////查看页面数据日志////////////////////////////////////
 Ext.BDP.FunLib.GetLogBtn=function(tableName){
    var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPDataChangeLogForPages&UserClass="+tableName;
    //+'&ClassNameDesc='+classDesc;
    var link=encodeURI(link)
    if ('undefined'!==typeof websys_getMWToken)
    {
		link += "&MWToken="+websys_getMWToken() //增加token
	}
    Ext.BDP.FunLib.LogBtn = new Ext.Toolbar.Button({
        text : $g('查看数据日志'),
        tooltip : $g('查看数据日志'),
        //id:'log_btn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('log_btn'),
        iconCls : 'icon-DP',
        handler : function() {
             var height=Ext.getBody().getViewSize().height-30;
			 var width= Ext.getBody().getViewSize().width*0.8 ;
             var LogWin = new Ext.Window({ 
					width:width,
		            height:height,
					title:$g('查看数据日志'),
                    //id:'LogWin',
                    layout : 'fit',
                    plain : true, 
                    modal : true,
                    frame : true,
                    autoScroll : false,
                    constrain : true,
                    closeAction : 'close' 
                });
            
            LogWin.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';                        
            LogWin.show();     
        }
    }); 
    return Ext.BDP.FunLib.LogBtn ;
 }
  
 ////////////////////查看页面数据生命周期/////////////////////////////////////////////////
  Ext.BDP.FunLib.GetHisLogBtn=function(ClassNameDesc) { 
    Ext.BDP.FunLib.HisLogBtn = new Ext.Toolbar.Button({
        text : $g('查看数据生命周期'),
        tooltip : $g('查看数据生命周期'),
        //id:'hislog_btn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('hislog_btn'),
        icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',
        handler : function() {
            var paramsArr= [];
            var paramsstr=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetLogParams");
            if ((paramsstr!="")&&(paramsstr!="undefined")){
		            paramsArr=paramsstr.split("^"); 
		            var objrowid=paramsArr[0];
		            var objdesc=paramsArr[1];
					var height= Ext.getBody().getViewSize().height-30 ;
					var width= Ext.getBody().getViewSize().width*0.8 ;
		            var SortWin = new Ext.Window({
		                    width:width,
		                    height:height,  
		                    //id:'SortWin',
		                    title:$g('数据生命周期'),
		                    layout : 'fit',
		                    plain : true,// true则主体背景透明
		                    modal : true,
		                    frame : true,
		                    autoScroll : false,
		                    collapsible : true,
		                    hideCollapseTool : true,
		                    titleCollapse : true,
		                    constrain : true,
                            icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',
		                    closeAction : 'close' 
		                });
		            var link="dhc.bdp.bdp.timeline.csp?actiontype=timeline&ClassN="+ClassNameDesc +"&OBJDESC="+objrowid+"&ObjectDesc="+objdesc;
				    var link=encodeURI(link)
				    if ('undefined'!==typeof websys_getMWToken)
			        {
						link += "&MWToken="+websys_getMWToken() //增加token
					}
		            SortWin.html='<iframe  src=" '+link+' " width="100%" height="100%"></iframe>';                        
		            SortWin.show();     
		          }
		          else
		          {
	               Ext.Msg.show({
	                        title:$g('提示'),
	                        minWidth:280,
	                        msg:$g('请选择需要查看的行!'),
	                        icon:Ext.Msg.WARNING,
	                        buttons:Ext.Msg.OK
	                    }); 
		          }
		        }
		    }); 
        return Ext.BDP.FunLib.HisLogBtn;
  }

 /// Function: 查看页面日志记录 
 Ext.BDP.FunLib.ShowBtnOrNotFun=function(){
   var result="";
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   var btnLogFlag=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","IfShowLogBtn",Ext.BDP.FunLib.TableName); 
   var btnLogArr=[];
   /// 显示日志
   btnLogArr=btnLogFlag.split("^");
   if (btnLogArr[0]==0){
      result=0; // 隐藏
   }
   else if(btnLogArr[2]==0)
   {
     result=0;
   }
   else
   {
     result=1;
   }
     return result;
  }
  
  /// Function: 查看页面数据生命周期  
 Ext.BDP.FunLib.ShowLifeBtnOrNotFun=function(){
   var result="";
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   var btnLogFlag=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","IfShowLogBtn",Ext.BDP.FunLib.TableName); 
   var btnLogArr=[];
   /// 显示日志
   btnLogArr=btnLogFlag.split("^");
   if (btnLogArr[1]==0){
      result=0; // 隐藏
   }
   else if(btnLogArr[2]==0)
   {
     result=0;
   }
   else
   {
     result=1;
   }
     return result;
  }
  
  ////////////////////////////////// 检索类别 //////////////////////////////////////
  Ext.BDP.FunLib.LookUpWinForm = new Ext.FormPanel({
                //id : 'lookupform',
                width:300,
                height:150,
                frame:true,
                defaults : {
                    border : false
                },
                items : [{
                    xtype: 'radio', 
                    id:'LookUpA',
                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('LookUpA'),
                    boxLabel: $g('精确检索'),
                    name: 'checkuptype',
                    inputValue: 'A' 
                }, {
                    xtype: 'radio', 
                    id:'LookUpF',
                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('LookUpF'),
                    checked: true,
                    name: 'checkuptype',
                    boxLabel: $g('模糊检索'),
                    inputValue: 'F' 
                }, {
                    xtype: 'radio', 
                    id:'LookUpL',
                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('LookUpL'),
                    name: 'checkuptype',
                    labelSeparator: '',
                    boxLabel: $g('左匹配检索'),
                    inputValue: 'L' 
                }]  
        }); 
         
      Ext.BDP.FunLib.LookUpWin = new Ext.Window({
            id:'lookupwin',
            width:300,
            height:200,
            title:"<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"cog_edit.png' style='border: 0px'>"+$g('【描述/别名】检索配置'),
	        modal : true,
	        frame : true,
	        bodyStyle : 'padding:3px',
	        buttonAlign : 'center',
	        closeAction : 'hide',
            items:[Ext.BDP.FunLib.LookUpWinForm]  , 
			buttons : [{
				text : $g('保存'),
				iconCls : 'icon-save', 
				handler : function() {
						TypeVal="";
                        if (Ext.getCmp('LookUpA').getValue()==true) TypeVal="A";
                        if (Ext.getCmp('LookUpL').getValue()==true) TypeVal="L";
                        if (Ext.getCmp('LookUpF').getValue()==true) TypeVal="F";
	                    var flag=tkMakeServerCall("web.DHCBL.BDP.BDPAlias","SaveLookUpConfig",Ext.BDP.FunLib.LookUpTableName,TypeVal);    
                        if (flag==1){
                              Ext.Msg.show({
                                title : '<font color=blue>'+$g('提示')+'</font>',
                                msg : '<font color=red>'+$g('保存成功!')+'</font>',
                                icon : Ext.Msg.INFO,
                                buttons : Ext.Msg.OK 
                           });
						   Ext.BDP.FunLib.LookUpWin.hide(); 
                        }
						else{
							 Ext.Msg.show({
                                title : '<font color=blue>'+$g('提示')+'</font>',
                                msg : '<font color=red>'+$g('保存失败!')+'</font>',
                                icon : Ext.Msg.INFO,
                                buttons : Ext.Msg.OK 
                           });
						}						
				}
			}, {
				text : $g('关闭'),
				iconCls : 'icon-close',
				handler : function() {
					Ext.BDP.FunLib.LookUpWin.hide(); 
				}
			}],
            listeners : {
                "show" : function() { 
	                 var ConfigVal=tkMakeServerCall("web.DHCBL.BDP.BDPAlias","GetConfig",Ext.BDP.FunLib.LookUpTableName); // alert(ConfigVal)
	                 if (ConfigVal!=""){
	                    Ext.getCmp('LookUp'+ConfigVal).setValue(true);
	                 }
	            },
	            "hide" :  function(){
                       
	               },
	            "close" : function() {  
                
                }
            }
    });
   
   Ext.BDP.FunLib.GetLookUpBtnFun=function(tableName) { 
    Ext.BDP.FunLib.LookUpTableName=tableName;
    Ext.BDP.FunLib.LookUpConfigbtn = new Ext.Toolbar.Button({
                text : $g('检索配置'),
                tooltip : $g('检索配置'),
                ///id:'lookupbtn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('lookupbtn'),
                icon: Ext.BDP.FunLib.Path.URL_Icon+'cog_edit.png',
                handler : function OpenLookUpWin() {
                    Ext.BDP.FunLib.LookUpWin.show();                
                }
            });
        return  Ext.BDP.FunLib.LookUpConfigbtn;
   } 
   
     ///////////////////////////////////////////////////////////////////////////////    
    ///用于根据分辨率设置grid显示条数  ybq   
	   
	   
	   
   ////////////////////////////////日志功能 结束////////////////////////////////////////////////////////// 
 // Ext.BDP.FunLib.ShowBtnOrNotFun();
/**以下均为测试用**/
/*Ext.BDP.FunLib.Component.ValidTextField = Ext.extend(Ext.form.TextField,{           	//----------CTPCPRowId1 表单主Rowid
	    allowBlank:false,
		validationEvent : 'blur',
		invalidText : '该描述已经存在!',
	    listeners : {
	        'change' : Ext.BDP.FunLib.Component.ValidData       			
	    }
	});*/
/* var json = "{ControlId1:{Disable:'Y'},ControlId2:{Disable:'Y',Hidden:'N'}}";
Ext.BDP.FunLib.Component.SetPropertyValue(json);

alert(Ext.BDP.FunLib.Component.HiddenArray["ControlId1"]);*/

	
	
	/****************************关联版本按钮部分**基础数据平台-李可凡**2020年2月26日***************************/
	function GetVersionWin(objectName,objectId,callback){
	    var _Versiongridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersionLinkData&pClassQuery=GetVersionForCloud" }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'LinkFlag', mapping : 'LinkFlag', type : 'string' }, 
	                            {name : 'VersionID',mapping : 'VersionID',type : 'string'},
	                            {name : 'Version',mapping : 'Version',type : 'string' }, 
	                            {name : 'LinkID',mapping : 'LinkID',type : 'string' } 
	                        ]) 
	     });
	     
	   var gridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _VersiongridObj.getStore().getAt(rowIndex).set("LinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _VersiongridObj.getStore().getAt(rowIndex).set("LinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _VersiongridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 550,
	                height : 350,
	                closable : true,
	                store : _Versiongridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:gridsm,
	                columns : [gridsm,
	                       	{header : '是否关联', width : 80,sortable : true, dataIndex : 'LinkFlag',hidden:true}, 
	                        {header : '版本号ID',width : 80, sortable : true, dataIndex : 'VersionID',hidden:true},
	                        {header : '版本号', width : 160, sortable : true, dataIndex : 'Version'}, 
	                        {header : '与版本号对照ID', width : 120,  sortable : true,  dataIndex : 'LinkID',hidden:true }],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });
	        
		var obj = new Ext.Window({
		        title : '关联版本（请点击左侧勾选框进行关联，保存）',
		        width : 550,
		        height : 350,
		        layout : 'fit',
		        plain : true, 
		        modal : true,
		        frame : true,
		        //autoScroll : true,
		        collapsible : true,
		        hideCollapseTool : true,
		        titleCollapse : true,
		        bodyStyle : 'padding:3px',
		        constrain : true,
		        closeAction : 'hide',
		        buttonAlign : 'center',
		        items : [_VersiongridObj],
		        buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						handler : function() {	
							var linkstr="";
						    _VersiongridObj.getStore().each(function(record){
								if(linkstr!="") linkstr = linkstr+"^";
								linkstr = linkstr+record.get('VersionID')+'$'+record.get('LinkFlag');
						    }, this);
						    Ext.Ajax.request({
								url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersionLinkData&pClassMethod=UpdateVersion",
								method:'POST',
								params:{
									//'tableName':objectName,
									'dataid':objectId,
									'VersionIDs':linkstr
								},
								callback : function(options, success, response) {
									if (success) {
										obj.hide();
										if ("function" == typeof callback) callback() //调用回调函数
									} 
									else {
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接！',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
							});  
						}
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							obj.hide();
						}
				}],
		        listeners : {
                        "show" : function(){
                                _VersiongridObj.getStore().baseParams={tablename : objectName, dataid : objectId };
								_VersiongridObj.getStore().load({
										scope: this,
										callback : function(records, options, success) {
											var records=[];//存放选中记录  
											for(var i=0;i<_VersiongridObj.getStore().getCount();i++){  
												var record = _VersiongridObj.getStore().getAt(i);  
												if(record.data.LinkFlag=='Y'){ records.push(record);   }  
											}  
											gridsm.selectRecords(records);//执行选中已对照的版本记录  
										}
								});              
                        }
                    }
		    });
		    return obj;
	}
	
	///关联版本按钮
	function GetVersionWinButton(callback){
		var btnobj = new Ext.Toolbar.Button({
			text : '关联版本',
			iconCls : 'button-example',
			hidden:HospListHiddenFlag,  
			handler : function() {
				if ("function" == typeof callback) callback() //调用回调函数
			}
		});
		return btnobj;
	}
	
	/*关联版本按钮调用示范
	var VersionWinButton=GetVersionWinButton(function(){
		if (grid.selModel.hasSelection()) {
			var VersionWin=GetVersionWin(Ext.BDP.FunLib.TableName,grid.getSelectionModel().getSelections()[0].get("MRCIDRowId"),function(){
			})
			VersionWin.show();
		}
	})
	*/

	/******************************关联版本按钮完******************************/
