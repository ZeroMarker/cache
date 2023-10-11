/**
 * @author Administrator
 */
 var delimit="|";
function speceachItem(item,index,length) {   
   
  //alert(item.id ); 
	if (item.xtype=="label")
	{
		if (item.text=="*")
		{
			document.getElementById(item.id).style.color="red";
		}
		inserthash(item,item.x+"!"+item.y+"!"+item.text);
 

	}if (item.xtype=="panel")
	{
		inserthash(item,item.x+"!"+item.y+"!"+item.text);
 

	}
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.getValue() != "") {
				//alert("dd");
				comboret = comboret + getitmid(item.id)+ delimit + formatDate(item.getValue()) + "!date^";
			} 
		    inserthash(item,item.x+"!"+item.y+"!"+item.getValue());
 		//	inserthash(item,"datefield");
   
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.getValue() != "") {
				comboret = comboret + getitmid(item.id)+ delimit + item.getValue() + "!time^";
			}
		 inserthash(item,item.x+"!"+item.y+"!"+item.getValue());
      
    }   if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;+"!"+item.lastSelectionText
			if (item.getValue() != "") {
				comboret = comboret + getitmid(item.id) + delimit + item.getValue() + "^";
				 inserthash(item,item.x+"!"+item.y+"!"+item.lastSelectionText);
				 //alert(item.lastSelectionText);
			}
			else {
				comboret = comboret + getitmid(item.id) + delimit  + "^";
			}
			//alert(comboret);
           
    } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+getitmid(item.id)+delimit+item.getValue()+"^";   
           inserthash(item,item.x+"!"+item.y+"!"+item.getValue());
      
    } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+getitmid(item.id)+delimit+item.getRawValue()+"^";   
            inserthash(item,item.x+"!"+item.y+"!"+item.getRawValue());
    } 
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址
			//debugger;    
			if (item.checked==true) checkret=checkret+getitmid(item.id)+delimit+item.boxLabel+"^";   
            if (item.checked==true) inserthash(item,item.x+"!"+item.y+"!"+item.boxLabel);
    } 
	 if (item.xtype=="radio") {   
            //修改下拉框的请求地址
			//debugger;    
			if (item.checked==true) checkret=checkret+getitmid(item.id)+delimit+item.boxLabel+"^";   
            if (item.checked==true) inserthash(item,item.x+"!"+item.y+"!"+item.boxLabel);
    } 
	   
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(speceachItem, this);   
    }   
} 
function eachItem(item,index,length) {   
   
  //alert(item.id ); 
    if (item.xtype=="label")
	{
		if (item.text=="*")
		{
			document.getElementById(item.id).style.color="red";
		}
	}
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.getValue() != "") {
				//alert("dd");
				comboret = comboret + getitmid(item.id)+ delimit + formatDate(item.getValue()) + "!date^";
			} 
			
 			inserthash(item,"datefield");
   
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.getValue() != "") {
				comboret = comboret + getitmid(item.id)+ delimit + item.getValue() + "!time^";
			}
			inserthash(item,"timefield");
      
    }   if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;+"!"+item.lastSelectionText
			if (item.getValue() != "") {
				comboret = comboret + getitmid(item.id) + delimit + item.getValue() + "^";
			}
			else {
				comboret = comboret + getitmid(item.id) + delimit  + "^";
			}
			//alert(comboret);
            inserthash(item,"combo");
    } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+getitmid(item.id)+delimit+item.getValue()+"^";   
            inserthash(item,"textfield");
      
    } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+getitmid(item.id)+delimit+item.getRawValue()+"^";   
            inserthash(item,"textarea");
    } 
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址
			//debugger;    
			if (item.checked==true) checkret=checkret+getitmid(item.id)+delimit+item.boxLabel+"^";   
             inserthash(item,"checkbox"+"^"+item.boxLabel);
    } 
	 if (item.xtype=="radio") {   
            //修改下拉框的请求地址
			//debugger;    
			if (item.checked==true) checkret=checkret+getitmid(item.id)+delimit+item.boxLabel+"^";   
             inserthash(item,"radio"+"^"+item.boxLabel);
    } 
	   
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem, this);   
    }   
} 
function getitmid(itmid)
{
	if (itmid.indexOf('S-')!=-1)
	{
	  var arr=itmid.split('-');	
	  return arr[1];
	 
	}else
	{
		return itmid;
	}
	
	
}  
function inserthash(item,typ)
{
			  if (ht.contains(item.id)) {
				}
				else {
				ht.add(item.id, typ)
			    }
} 
function sethashvalue1(ha,tm,flag)
{
	 for (i=0;i<tm.length;i++)
	 {
	 	var v=tm[i].split('|');
		var id=v[0];
		if (flag!="") id=flag+id;
		var vl=v[1];
		ha.add(id,vl);
	 }
} 
function sethashvalueflag(ha,tm,flag)
{
	 for (i=0;i<tm.length;i++)
	 {
	 	var v=tm[i].split(flag);
		var id=v[0];
		var vl=v[1];
		ha.add(id,vl);
	 }
} function sethashvalue(ha,tm)
{
	 for (i=0;i<tm.length;i++)
	 {
	 	var v=tm[i].split("|");
		var id=v[0];
		var vl=v[1];
		ha.add(id,vl);
	 }
} 

function setcheckvalue(itmkey,val)
{
  var itm=Ext.getCmp(itmkey);
  //item.boxLabel
  var arr=val.split(';');
  for (i=0;i<arr.length;i++)
  {
  	 if (itm.boxLabel==arr[i])
	 {
	 	itm.setValue(true);
	 }
  }
	
} 

function setcheckvalue1(itmkey,val)
{
  var itm=Ext.getCmp(itmkey);
  //item.boxLabel
  var arr=val.split(';');
  for (i=0;i<arr.length;i++)
  { 
    if (arr[i].indexOf("☑")>-1)   //多选
    {var vals=arr[i].replace("☑","")  //多选
  	 if (itm.boxLabel==vals)
	   {
	 	  itm.setValue(true);
	   }
	 }
  }
	
} 

/**********************一。验证类*****************************/
//对象是否 存在
function isObj(str)
{
if(str==null||typeof(str)=='undefined')
return false;
return true;
}
//去除字符串中的空格
function strTrim(str)
{
if(!isObj(str))
return 'undefined';
str=str.replace(/^\s+|\s+$/g,'');
return str;
}
/**********************1数字验 证******************************/
//1。1整数
//整数或者为空
function isIntOrNull(str){
if(!isObj(str))//判断对象是否存在
return 'undefined';
return isNull(str)||isInt(str);
}
//必需是整数
function isInt(str){
var reg = /^(-|\+)?\d+$/ ;
return reg.test(str);
}
//1.2 小数
//小数或者为空
function isFloatOrNull(str){
if(!isObj(str))//判 断对象是否存在
return 'undefined';
if(isInt(str))
return true;
return isNull(str)||isFloat(str);
}
//必需是小数
function isFloat(str){
if(isInt(str))
return true;
var reg = /^(-|\+)?\d+\.\d*$/;
return reg.test(str);
}
//1.3 数字大小判断
//数i不能大于数y
function iMinY(i , y){
if(!isObj(i)||!isObj(y))// 判断对象是否存在
return 'undefined';
if(!(isFloat(i)&&isFloat(y)))
return '比较的必须是数字类型'
if(i<=y)
return true;
return false;
}
// 数i不能小于数y
function iMaxY(i , y){
if(!isObj(i)||!isObj(y))//判断对象是 否存在
return 'undefined';
if(!(isFloat(i)&&isFloat(y)))
return '比较的必须是数字类型'
if(i>=y)
return true;
return false;
}
/**********************1 数字验证******************************/    

//计算评分
var MultiScore = ""; //M单元总分用
function initEvents() {
	try {
		if (ScoreItem.length != ValueItem.length) return;
		if (ScoreItem.length != NameItem.length) return;
		if (ScoreItem.length != DateItem.length) return;
		
		//所有需要评分的M单元
		for (var j = 0; j < ScoreItem.length; j++) {
			var SingleItem = ScoreItem[j];
			if (SingleItem == undefined) continue;
			if (SingleItem == "") continue;

			var tmpStr = SingleItem.split("^")
			for (var i = 0; i < tmpStr.length; i++) {
				var Item = tmpStr[i];
				if (Item == "") continue;
				var mainObj = Ext.getCmp(Item);
				if (!mainObj) continue;
				if (mainObj.xtype == "panel") {
					//M单元
					if (mainObj.items && mainObj.items.getCount() > 0) {
						mainObj.items.each(MulitCheckBox, this);
					}
					else {
						continue;
					}
				}
				else if (mainObj.xtype == "combo") {
					//O单元
					mainObj.on("select", function () {
						CalculateScore(this.id);
					});
					mainObj.on("change", function () {
						CalculateScore(this.id);
					})
				}
				else if (mainObj.xtype == "textfield") {
					//S单元
					mainObj.on("blur", function () {
						CalculateScore(this.id);
					});
					mainObj.on("focus", function () {
						CalculateScore(this.id);
					});
					mainObj.on("change", function () {
						CalculateScore(this.id);
					})
				}
				else {
					continue;
				}
			}
		}
	} catch (ex) {

	}
}
function MulitCheckBox(item, index, length) {
	if (item.xtype == "checkbox") {
		item.on("check", function () {
			if (this.id.indexOf("_") > -1) {
				CalculateScore(this.id.split("_")[0]);
			}
		})
	}
}

function MulitScoreItem(item, index, length) {

	if (item.xtype == "checkbox") {
		if (item.checked) {
			var tmpArr2 = item.id.split("_");
			if (tmpArr2.length > 1) {
				MultiScore = MultiScore + "^" + tmpArr2[1];
			}
		}
	}
}
function CalculateScore(Item) {
	
	var flag = false;
	for (var j = 0; j < ScoreItem.length; j++) {
		var SingleItem = ScoreItem[j];
		if (SingleItem == undefined) continue;
		if (SingleItem == "") continue;
		if (flag) break;

		if (SingleItem.indexOf(("^" + Item + "^")) > -1) {
			var ret = "";
			var tmpStr = SingleItem.split("^")
			for (var i = 0; i < tmpStr.length; i++) {
				var Item = tmpStr[i];
				if (Item == "") continue;
				var mainObj = Ext.getCmp(Item);
				if (!mainObj) continue;

				if (mainObj.xtype == "panel") {
					//M单元
					if (mainObj.items && mainObj.items.getCount() > 0) {
						MultiScore = "";
						mainObj.items.each(MulitScoreItem, this);
						if (MultiScore != "") {
							ret = ret + "^" + MultiScore;
						}
					}
					else {
						continue;
					}
				}
				else {
					var score = mainObj.getValue();
					if (score.indexOf("√") > -1) {
						score = 1;
					}
					if (score != "") ret = ret + "^" + score;
				}
			}

			if (ret != "") {
				var retInfo = tkMakeServerCall("web.DHCLCNUREXCUTE", "SetNum", ret);
				if ((ValueItem[j] != undefined) && (ValueItem[j] != "")) {
					var scores = Ext.getCmp(ValueItem[j]);
					if (scores) scores.setValue(retInfo);
					if ((NameItem[j] != undefined) && (NameItem[j] != "")) {
						var name = Ext.getCmp(NameItem[j]);
						if ((name) && (name.getValue() == "")) {
							name.setValue(session['LOGON.USERNAME']);
						}
					}
					if ((DateItem[j] != undefined) && (DateItem[j] != "")) {
						var dateObj = Ext.getCmp(DateItem[j]);
						if ((dateObj) && (dateObj.getValue() == "")) {
							var curDate = tkMakeServerCall("web.DHCNurseRecordComm", "GetCurDate");
							dateObj.setValue(curDate);
						}
					}
					if ((TimeItem[j] != undefined) && (TimeItem[j] != "")) {
						var timeObj = Ext.getCmp(TimeItem[j]);
						if ((timeObj) && (timeObj.getValue() == "")) {
							var curTime = tkMakeServerCall("web.DHCNurseRecordComm", "GetCurTime");
							timeObj.setValue(curTime);
						}
					}
				}
				else {
					if ((retInfo != "") && (ValueItem[j] == "")) {
						if ((NameItem[j] != undefined) && (NameItem[j] != "")) {
							var name = Ext.getCmp(NameItem[j]);
							if ((name) && (name.getValue() == "")) {
								name.setValue(session['LOGON.USERNAME']);
							}
						}
						if ((DateItem[j] != undefined) && (DateItem[j] != "")) {
							var dateObj = Ext.getCmp(DateItem[j]);
							if ((dateObj) && (dateObj.getValue() == "")) {
								var curDate = tkMakeServerCall("web.DHCNurseRecordComm", "GetCurDate");
								dateObj.setValue(curDate);
							}
						}
						if ((TimeItem[j] != undefined) && (TimeItem[j] != "")) {
							var timeObj = Ext.getCmp(TimeItem[j]);
							if ((timeObj) && (timeObj.getValue() == "")) {
								var curTime = tkMakeServerCall("web.DHCNurseRecordComm", "GetCurTime");
								timeObj.setValue(curTime);
							}
						}
					}
				}
			}
			else {
				//if (ret.replace(/\|/gi,"「"))
				var scores = Ext.getCmp(ValueItem[j]);
				if (scores) scores.setValue("");

				if ((NameItem[j] != undefined) && (NameItem[j] != "")) {
					var name = Ext.getCmp(NameItem[j]);
					if (name) {
						name.setValue("");
					}
				}
				if ((DateItem[j] != undefined) && (DateItem[j] != "")) {
					var dateObj = Ext.getCmp(DateItem[j]);
					if (dateObj) {
						dateObj.setValue("");
					}
				}
				if ((TimeItem[j] != undefined) && (TimeItem[j] != "")) {
					var timeObj = Ext.getCmp(TimeItem[j]);
					if (timeObj) {
						timeObj.setValue("");
					}
				}
			}
		}
	}
	return;
}   