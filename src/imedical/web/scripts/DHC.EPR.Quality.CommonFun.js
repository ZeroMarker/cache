var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_Up="^";
var CHR_Tilted="/";

function validateControl(controlID, type, errString) 
{
    var strValue = document.getElementById(controlID).value;
    var tmp = "";
    if (strValue == null) {
        window.alert(errString);
        return false;
    }
    switch (type) {
        case "string":
            if (strValue == "") {
                window.alert(errString);
                return false;
            }
            break;
        case "int":
            if (!isNaN(parseInt(strValue))) {
                window.alert(errString);
                return false;
            }
            break;
        case "float":
            if (!isNaN(parseFloat(strValue))) {
                window.alert(errString);
                return false;
            }
            break;
    }
    return true;
}

//Add Item to ListBox Control
function AddListItem(controlID, itemCaption, itemValue, pos) 
{
    var obj = document.getElementById(controlID);
    var objItm = document.createElement("OPTION");
    if (pos >= 0) {
        obj.options.add(objItm, pos);
    } else {
        obj.options.add(objItm);
    }
    objItm.innerText = itemCaption;
    objItm.value = itemValue;
    return objItm;
}

//get value of an element
function AddListItem(controlID, itemCaption, itemValue, pos) 
{
    var obj = document.getElementById(controlID);
    var objItm = document.createElement("OPTION");
    if (pos >= 0) {
        obj.options.add(objItm, pos);
    } else {
        obj.options.add(objItm);
    }
    objItm.innerText = itemCaption;
    objItm.value = itemValue;
    return objItm;
}

//get value of an element
function getElementValue(controlID, objDoc, getCaption) 
{
    var strValue = "";
    if (objDoc != null) {
        var obj = objDoc.getElementById(controlID);
    } else {
        var obj = document.getElementById(controlID);
    }
    if (!obj) {
        return strValue;
    }
    switch (obj.nodeName) {
        case "INPUT":
            switch (obj.type) {
                case "checkbox":
                    strValue = obj.checked;
                    strValue = (strValue == true ? "Y" : "N")
                    break;
                default:
                    strValue = obj.value;
                    break;
            }
            break;
        case "TEXTAREA":
            strValue = obj.value;
            break;
        case "SELECT":
            for (var i = 0; i < obj.options.length; i++) {
                var objOption = obj.options.item(i);
                if (objOption.selected) {
                    strValue += (strValue == "" ? "" : ",") + (getCaption ? objOption.innerText : objOption.value);
                }
            }
            break;
        case "LABEL":
            strValue = obj.innerText;
            break;
        case "A":
            strValue = obj.innerText;
            break;

    }
    //window.alert(obj.id + "  " + obj.nodeName + "   " + obj.type + "    " + obj.value);
    return strValue;
}

//set an element value
function setElementValue(controlID, newValue, objDoc) 
{
    if (newValue == " ") newValue = "";
    if (objDoc != null) {
        var obj = objDoc.getElementById(controlID);
    } else {
        var obj = document.getElementById(controlID);
    }
    if (!obj) {
        return;
    }
    switch (obj.nodeName) {
        case "INPUT":
            if (obj.type == "checkbox") {
                newValue = (((newValue == "Y") || (newValue == true)) ? true : false)
                obj.checked = newValue;
            } else {
                obj.value = newValue;
            }
            break;
        case "TEXTAREA":
            obj.value = newValue;
            break;
        case "SELECT":
            for (var i = 0; i < obj.options.length; i++) {
                if (obj.options.item(i).value == newValue) {
                    obj.options.item(i).selected = true;
                }
            }
            break;
        case "LABEL":
            obj.innerText = newValue;
            break;
        default:
            obj.value = newValue;
            break;
    }
}

function GetListData(objName) 
{
    var obj = document.getElementById(objName);
    var ret = "";
    if (obj) {
        switch (obj.type) {
            case "select-one":
                if (obj.options.length == 0) break;
                myidx = obj.selectedIndex;
                ret = obj.options[myidx].value;
                break;
            case "checkbox":
                if (obj.checked == true) {
                    ret = "Yes";
                } else {
                    ret = "No";
                }
                break;
            default:
                ret = obj.value;
                break;
        }
    }
    return ret;
}

//remove space for string
function LTrim(str) 
{
    //remove the leading space
    var i;
    for (i = 0; i < str.length; i++) {
        if (str.charAt(i) != " " && str.charAt(i) != " ")
            break;
    }
    str = str.substring(i, str.length);
    return str;
}

function RTrim(str) 
{
    var i;
    for (i = str.length - 1; i >= 0; i--) {
        if (str.charAt(i) != " " && str.charAt(i) != " ")
            break;
    }
    str = str.substring(0, i + 1);
    return str;
}

//remove blank of a string
function Trim(str)
{
	return LTrim(RTrim(str));
} 

//spit a string,and get first item
function GetCode(str, s) 
{
    var objArry = str.split(s);
    if (Trim(str) == "") {
        return "";
    }
    return (objArry[0] == undefined ? "" : objArry[0]);
}

//spit a string,and get 2nd item
function GetDesc(str, s) 
{
    var objArry = str.split(s);
    if (Trim(str) == "") {
        return "";
    }
    return (objArry[1] == undefined ? "" : objArry[1]);
}

//get element from string
function GetArryItem(str, delimiter, pos)
{
	var objArry = str.split(delimiter);
	if(Trim(str) == "")
	{
		return "";
	}
	return (objArry[pos] == undefined ? "" : objArry[pos]);
}

//format registration number
function FormatRegNo(str)
{
	tmp = str;
	while(tmp.length <8)
	{
		tmp = "0" + tmp;
	}
	return tmp;
}

//clear combo,listbox
function ClearListBox(controlID)
{
	var obj = document.getElementById(controlID);
	for(var i = obj.options.length - 1; i >= 0; i --)
	{
		obj.options.remove(i);
	}
}

//convert listbox to ComboBox
function MakeComboBox(controlID)
{
	var obj = document.getElementById(controlID);
	obj.multiple = false;
	obj.size = 1;
}

//get parameter from url string
//obj:window object
//key:item name
function GetParam(obj, key) 
{
    var url = obj.location.href;
    var strParams = "";
    var pos = url.indexOf("?");
    var tmpArry = null;
    var strValue = "";
    var tmp = "";
    if (pos < 0) {
        return "";
    }
    else {

        strParams = url.substring(pos + 1, url.length);
        tmpArry = strParams.split("&");
        for (var i = 0; i < tmpArry.length; i++) {
            tmp = tmpArry[i];
            if (tmp.indexOf("=") < 0)
                continue;
            if (tmp.substring(0, tmp.indexOf("=")) == key)
                strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
        }
        return strValue;
    }
}

//make choosing table
//hiddenPrefix??idden prefix
//isMulti  radio/checkbox
function MakeChoice(tblID, hiddenPrefix, isMulti) 
{
    var objTable = document.getElementById(tblID);
    var strValue = null;
    var objRow = null;
    var objCell = null;
    var obj = null;
    for (var i = 1; i < objTable.rows.length; i++) {
        objRow = objTable.rows.item(i);
        strValue = document.getElementById(hiddenPrefix + i).value;
        objCell = objRow.cells.item(0);
        if (isMulti) {
            obj = document.createElement("<input type='checkbox' name='choice' value='" + strValue + "'/>")
        }
        else {
            obj = document.createElement("<input type='radio' name='choice' value='" + strValue + "'/>")
        }
        objCell.appendChild(obj);
    }
}

function GetSelectValue(name) 
{
    var objArry = document.getElementsByName(name);
    var tmp = "";
    var obj = null;
    for (var i = 0; i < objArry.length; i++) {
        obj = objArry[i];
        if (obj.checked)
            tmp += obj.value + (tmp.length == 0 ? "" : ",");
    }
    return tmp;
}

//remove from listbox,combobox
function RemoveListItem(controlID, itemIndex ,objDoc)
{
	var objList = null;
	if(objDoc == null)
		objList = document.getElementById(controlID);
	else
		objList = objDoc.getElementById(controlID);
	if(itemIndex == null)
		objList.remove(objList.selectedIndex);
	else
		objList.remove(itemIndex);
	
}

//clear ListBox
function ClearListBox(controlID, objDoc)
{
	var objList = null;
	if(objDoc == null)
		objList = document.getElementById(controlID);
	else
		objList = objDoc.getElementById(controlID);
	for(var i = objList.options.length - 1; i >= 0; i --)
	{
		objList.remove(i);
	}
}

//validate user
//success:return user object else null;
//title:dialog Title
function ValidateUser(title)
{
	var objReturn = window.showModalDialog(
		"websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPRQ.ValidateUser" + "&Title=" + title ,
		"",
		"dialogHeight: 150px; dialogWidth: 400px");
	return objReturn;
}

//Add zero
//num: max length
function AddZero(str, num)
{
	var tmp = str;
	while(tmp.length < num)
	{
		tmp = "0" + tmp;
	}
	return tmp;
}

function SetControlVisitable(controlID, value, objDoc)
{
	var obj = null;
	if(objDoc == null)
		obj = document.getElementById(controlID);
	else
		obj = objDoc.getElementById(controlID);
	
	obj.style.visibility = (value ? "visible" : "hidden");

}

	
//************control the focus with return key*****
var objArryStep = new Array(); //


function AddToControlList(objControl)
{
	if(objControl != null)
	{
		objArryStep.push(objControl);
		objControl.onkeydown = ProcessReturnKey;
	}
}

function ProcessReturnKey()
{
	var obj = null;
	if(window.event == null)
		return;
	switch(window.event.keyCode)
	{
		case 13://return 
		case 40://,down
			for(var i = 0; i < objArryStep.length - 1; i ++)
			{
				obj = objArryStep[i];
				if(obj.id == window.event.srcElement.id)
				{
					obj = objArryStep[i + 1];
					obj.focus();
					break;
				}
			}				
			break;
		case 38: //up
			for(var i = objArryStep.length - 1; i > 0; i --)
			{
				obj = objArryStep[i];
				if(obj.id == window.event.srcElement.id)
				{
					obj = objArryStep[i - 1];
					obj.focus();
					break;
				}
			}				
			break;			
		default:
			//window.alert(window.event.keyCode);
			break;
	}
}

//convert string to Date Format"YYYY-MM-DD", and validate the contents
//available format:YYYY-MM-DD,YYYYMMDD,YYMMDD
function GetDateFromString(str)
{
var strYear = "";
var strMonth = "";
var strDay = "";
var objArry = null;
var dtTmp = null;

if(str.indexOf("-") != -1)
{
	objArry = str.split("-");
	strYear = objArry[0];
	strMonth = objArry[1];
	strDay = objArry[2];
}
else
{
	switch(str.length)
	{
		case 8:
			strYear = str.substr(0, 4);
			strMonth = str.substr(4, 2);
			strDay = str.substr(6, 2);
			break;
		case 6:
			strYear = str.substr(0, 2);
			if(strYear>= 50)
			{
				strYear = "19" + strYear;
			}
			else
			{
				strYear = "20" + strYear;
			}
			strMonth = str.substr(2, 2);
			strDay = str.substr(4, 2);
				break;
		default:
			//throw new Error(999, "Illegal Date Format!"); 
			break;
	}
}
dtTmp = new Date(strYear, new Number(strMonth).valueOf() - 1, strDay);
if(isNaN(dtTmp))
{
	return dtTmp;//throw new Error(999, "Illegal Date Format!");
}
strYear = dtTmp.getFullYear();
strMonth = dtTmp.getMonth() + 1;
if (dtTmp.getMonth() + 1 < 10) 
{
	strMonth = "0" + new String(dtTmp.getMonth() + 1);
}
strDay = new Number(strDay);
if (strDay < 10)
{
	strDay = "0" + new String(strDay);
}
return strYear + "-" + strMonth + "-" + strDay;
}

//create a Cookie
function SetCookie(sName, sValue)
{
date = new Date(2999, 11, 31);
document.cookie = sName + "=" + escape(sValue) + "; expires=" + date.toGMTString();
}

//delete a Cookie
function DelCookie(sName)
{
document.cookie = sName + "=" + escape(sValue) + "; expires=Fri, 31 Dec 1999 23:59:59 GMT;";
}

//get the Cookie collection of document
function GetCookieCollection()
{
var str = document.cookie;
var arry = null;
var objDic = new ActiveXObject("Scripting.Dictionary");
arry = str.split(";");
for(var i = 0; i < arry.length; i ++)
{
	objDic.Add(GetCode(arry[i], "="), GetDesc(arry[i], "="));
}
return objDic;
}

//encode Chinese characters
function StringEncode(str)
{
var ret = "";
for(var i = 0; i < str.length; i ++)
{
	ret += str.charCodeAt(i) + "."
}
return ret;
}
//decode  StringEncode
function StringDecode(str)
{
var ret = "";
if((str == "") || (str == null))
	return "";
	
var objArry = str.split(".");
for(var i = 0; i < objArry.length - 1; i ++)
{
	ret += String.fromCharCode(objArry[i])
}
return ret;
}

//format dade as "YYYY-MM-DD
function FormatDateString(str)
{
 var objArryDate = str.split("/");
var strDate = objArryDate[2] + "-" + objArryDate[1] + "-" + objArryDate[0];
return strDate;
}

//***********************************

//window.alert("Comm");

//Get Chinese
function GetChinese(MethodName, Ind) 
{
    var strMethod = document.getElementById(MethodName).value;
    var ret = cspRunServerMethod(strMethod, Ind);
    var tmpList = ret.split("^");
    return tmpList;
}

//Create AJAX ComboBox
function CreateICDDicQueryComboBox(DicType, Label)
{
var ds = new Ext.data.Store({
proxy: new Ext.data.HttpProxy(new Ext.data.Connection({
    url: 'dhc.eprq.dictionary.csp?DicName=' + DicType
})),
reader: new Ext.data.JsonReader({
    root: 'record',
    totalProperty: 'total',
    id: 'id'
}, [
    {name: 'id', mapping: 'id'},
    {name: 'code', mapping: 'code'},
    {name: 'desc', mapping: 'desc'},
    {name: 'alias', mapping: 'alias'}
])
});

// Custom rendering Template
var resultTpl = new Ext.XTemplate(
'<tpl for="."><div class="search-item">',
    '<B>{code}</B>{desc}',
'</div></tpl>'
);

var search = new Ext.form.ComboBox({
store: ds,
valueField:'id',
fieldLabel:Label,
displayField:'desc',
typeAhead: false,
loadingText: 'Searching...',
//width: 400,
queryDelay:1,
minChars:0, //Modified by liyang 2008-09-10  if user delete contents, we can clear listbox to make result correct.
pageSize:30,
tpl: resultTpl,
hideTrigger:true,
triggerAction: 'all',
itemSelector: 'div.search-item',
minListWidth:500
	
});
//window.alert('./dhc.eprq.dictionary.csp?DicName=' + DicType); 
return search; 
}


function CreateDicQueryComboBox(DicType, Label)
{
	var objProxy = new Ext.data.HttpProxy({
    url: 'dhc.eprq.dictionary.csp?DicName=' + DicType
});
	objProxy.conn.method = "GET";
var ds = new Ext.data.Store({
proxy: objProxy,
reader: new Ext.data.JsonReader({
    root: 'record',
    totalProperty: 'total',
    id: 'id'
}, [
    {name: 'id', mapping: 'id'},
    {name: 'code', mapping: 'code'},
    {name: 'desc', mapping: 'desc'},
    {name: 'resume', mapping: 'resume'}
])
});

// Custom rendering Template
var resultTpl = new Ext.XTemplate(
'<tpl for="."><div class="search-item">',
    '<B>{code}</B>{desc}',
'</div></tpl>'
);

var search = new Ext.form.ComboBox({
store: ds,
valueField:'id',
fieldLabel:Label,
displayField:'desc',
typeAhead: false,
loadingText: 'Searching...',
disableKeyFilter:true,
minChars:1,
pageSize:30,
queryDelay:5,
tpl: resultTpl,
hideTrigger:true,
triggerAction: 'all',
itemSelector: 'div.search-item',
minListWidth:500
	
});

ds.on('beforeload', function(ds, o){
var strArg =  ds.baseParams["query"];//search.getRawValue();
var strTmp = "";
for(var i = 0; i < strArg.length; i ++)
{
    strTmp += strArg.charCodeAt(i) + "-";
}
ds.baseParams["query"]=strTmp;
ds.proxy = new Ext.data.HttpProxy({url: '../csp/dhc.eprq.dictionary.csp?DicName='+DicType+'&query1=' + strTmp});
});  

return search; 
}

//Init AJAX ComboBox
// Label:Title for a combo box
//DicName: Dictionary name
function InitComboBox(Label, DicName) {
    var objStore = new Ext.data.SimpleStore({
        fields: [
            { name: 'RowID' },
            { name: 'Code' },
            { name: 'Desc' }
            //{name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
        ]
    });
    //objStore.loadData(myData);

    var objArry = GetDHCEPRQDictionaryArryByTypeFlag("MethodGetDHCEPRQDictionaryArryByTypeFlag", DicName, "Y");
    var objRec = null;
    var objItem = null;
    for (var i = 0; i < objArry.length; i++) {
        objItem = objArry[i];
        objRec = new Ext.data.Record(
        {
            RowID: objItem.RowID,
            Code: objItem.Code,
            Description: objItem.Description
        }
        );
        objStore.add([objRec]);
    }
    var resultTpl = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
        '<B>{code}</B>{desc}',
        '</div></tpl>'
    );

    var search = new Ext.form.ComboBox({
        store: objStore,
        valueField: 'RowID',
        fieldLabel: Label,
        displayField: 'Desc',
        typeAhead: false,
        //loadingText: 'Searching...',
        //width: 400,
        minChars: 1,
        pageSize: 30,
        tpl: resultTpl,
        hideTrigger: true,
        triggerAction: 'all',
        itemSelector: 'div.search-item'

    });
    return search;
}

function gSetFocus(eleName) 
{
    var obj = document.getElementById(eleName);
    if (obj) { obj.focus(); }
}

//Use for EXJ Frame, create DataStore
function CreateDicStore(arry, valueField, DisplayField) 
{
    var objStore = new Ext.data.SimpleStore(
        {
            fields:
            [
                { name: 'RowID' },
                { name: 'Description' },
                { name: 'Obj' }
            ]
        }
    );
    var objRec = null;
    var objData = null;
    for (var i = 0; i < arry.length; i++) {
        objData = arry[i];
        eval("objRec = new Ext.data.Record({" +
  	            "RowID : objData." + valueField + "," +
  	            "Description:objData." + DisplayField + "," +
  	            "Obj:objData" +
  	            "}" +
  	          ");");
        objStore.add([objRec]);
    }
    return objStore;
}

//select item for EXJ Frame JS
function SelectFirstComboBoxItem(objCbo) 
{
    objStore = objCbo.initialConfig.store;
    var objData = null;
    if (objStore.getCount() > 0) {
        objData = objStore.getAt(0);
        objCbo.setValue(objData.get(objCbo.initialConfig.valueField));
    }
}   

///Format string as len
function formatString(Instring, Len) 
{
    if (Instring.length >= Len) return Instring;
    if (Instring == "") return Instring;
    var AddZero = Len - Instring.length;
    var tmpString = Instring;
    for (i = 0; i < AddZero; i++) {
        tmpString = "0" + tmpString;
    }
    return tmpString;
}

//Replace string
function ReplaceText(str, find, repl) 
{
    var strTmp = str;
    while (strTmp.indexOf(find) >= 0) {
        strTmp = strTmp.replace(find, repl);
    }
    return strTmp;
}

//Get Record Object from Grid
function GetGridSelectedData(objGrid) 
{
    var objSel = objGrid.getSelectionModel();
    var objData = null;
    if (objSel.selections.items.length > 0) {
        objData = objSel.selections.items[0];
    }
    return objData;
}

//Set combo box value by any field
//Param:
//objCombo: combo to operate
//ValueFieldName: ComboBox's value field
//FieldName: Field to use as find criteria
//FieldValue: find value
//Return value: if set value return TRUE else return FALSE
function SetComboValue(objCombo, ValueFieldName, FieldName, FieldValue) 
{
    var objStore = objCombo.initialConfig.store;
    if (objStore.getCount() == 0)
        return null;
    var strValue = objCombo.getValue();
    var objValue = null;
    var objRec = null;
    for (var i = 0; i < objStore.getCount(); i++) {
        objRec = objStore.getAt(i);
        if (objRec.get(FieldName) == FieldValue) {
            objValue = objRec.get(ValueFieldName);
            objCombo.setValue(objValue);
            return true;
        }
    }
    return false;
}

//Get combo's current record object
function GetComboSelRecord(objCombo) 
{
    var objStore = objCombo.initialConfig.store;
    var valueFieldName = objCombo.initialConfig.valueField;
    if (objStore.getCount() == 0)
        return null;
    var strValue = objCombo.getValue();
    var objRec = null;
    for (var i = 0; i < objStore.getCount(); i++) {
        objRec = objStore.getAt(i);
        if (objRec.get(valueFieldName) == strValue)
            return objRec
    }
    return null;
}

function GetWebConfig(encmeth) 
{
    var objWebConfig = new Object();
    if (encmeth != "") {
        ret = cspRunServerMethod(encmeth);
        if (ret != "") {
            var TempFileds = ret.split(String.fromCharCode(1));
            objWebConfig.CurrentNS = TempFileds[0];
            objWebConfig.MEDDATA = TempFileds[1];
            objWebConfig.LABDATA = TempFileds[2];
            objWebConfig.Server = "cn_iptcp:" + TempFileds[3] + "[1972]";
            objWebConfig.Path = TempFileds[4];
            objWebConfig.LayOutManager = TempFileds[5];
        }
    } else {
        objWebConfig = null;
    }
    return objWebConfig;
}

function setElementDisabled(controlID, val) 
{
    var obj = document.getElementById(controlID);
    if (obj) {
        obj.disabled = val;
    }
    return;
}