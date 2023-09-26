// DHCPEOrdSets.List.js
/// by zhongricheng

var IsSelect=false;
var ItemMap = new Map();

function BodyLoadHandler() {
	var obj;
	
	obj=document.getElementById("BDelete");
	if (obj) { obj.onclick=BDelete_click; }
	
	obj=document.getElementById("BUp");
	if (obj) { obj.onclick=BUp_click; }
	
	obj=document.getElementById("BDown");
	if (obj) { obj.onclick=BDown_click; }

	obj=document.getElementById("BUpdateAmount");
	if (obj) { obj.onclick=BUpdateAmount_click; }

	
	ColorTblColumn();
}
function BUpdateAmount_click() {
	var ARCOSRowid="",ARCOSAmount="";
	var obj=document.getElementById("ARCOSRowid"); // 医嘱套ID
	if (obj.value!="") { ARCOSRowid=obj.value; }
	
	var obj=document.getElementById("ARCOSAmount"); // 医嘱套ID
	if (obj.value!="") { ARCOSAmount=obj.value; }
  
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.Price&ARCOSRowid="+ARCOSRowid+"&ARCOSAmount="+ARCOSAmount;
	//alert(url)
	websys_createWindow(url, true, "height=500, width=800, top=200, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

function BDelete_click() {
	var obj;
	
	obj=document.getElementById("ARCOSRowid");  // 医嘱套ID
	if (obj.value!="") { ARCOSRowid=obj.value; }
	else { alert("没有选择医嘱套");return false; }
	
	var i = selectedRowObj.rowIndex;
	if(i>0) {
		obj=document.getElementById("ARCOSItemRowidz"+i);
		if(obj.value!="")  ARCOSItemRowid = obj.value;
	}
	else {
		alert("请选择项目再进行删除！");return false;
	}
	
	var ret = tkMakeServerCall("web.DHCARCOrdSets","DeleteItem",ARCOSItemRowid)
	if (ret==0) {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.List&ARCOSRowid="+ARCOSRowid+"&QueryFlag=1";
		location.href=lnk;
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=OrdSets.List&Type=Item";
		parent.frames["PreItemList.Qry2"].location.href=lnk;
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=OrdSets.List&Type=Lab";
		parent.frames["PreItemList.Qry3"].location.href=lnk;
		alert("删除成功！");
	}
	else { alert("删除失败！"); }
}
// 上移
function BUp_click() {
	var i = selectedRowObj.rowIndex;
	if (i > 0) {
		// 序号和ID
		var obj=document.getElementById("ITMSerialNoz"+i);
		if (obj.value!="") { var toup = obj.value; }
		var obj=document.getElementById("ARCOSItemRowidz"+i);
		if (obj.value!="") { var upid = obj.value; }
		
		// 上一行的序号和ID
		var obj=document.getElementById("ITMSerialNoz"+(i-1));
		if (obj.value!="") { var todown = obj.value; }
		else { return false; }
		var obj=document.getElementById("ARCOSItemRowidz"+(i-1));
		if (obj.value!="") { var downid = obj.value; }
		else { return false; }
		
        var rtn=UpdateSerialNO(downid,toup);
        var rtn=UpdateSerialNO(upid,todown);
        var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.List&ARCOSRowid="+ARCOSRowid+"&QueryFlag=1";
		location.href=lnk;
	}
}
// 下移
function BDown_click() {
		var i = selectedRowObj.rowIndex;
	if (i > 0) {
		// 序号和ID
		var obj=document.getElementById("ITMSerialNoz"+i);
		if (obj.value!="") { var todown = obj.value; }
		var obj=document.getElementById("ARCOSItemRowidz"+i);
		if (obj.value!="") { var downid = obj.value; }
		
		// 下一行的序号和ID
		var obj=document.getElementById("ITMSerialNoz"+(i+1));
		if (obj.value!="") { var toup = obj.value; }
		else { return false; }
		var obj=document.getElementById("ARCOSItemRowidz"+(i+1));
		if (obj.value!="") { var upid = obj.value; }
		else { return false; }
		
        var rtn=UpdateSerialNO(downid,toup);
        var rtn=UpdateSerialNO(upid,todown);
        var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.List&ARCOSRowid="+ARCOSRowid+"&QueryFlag=1";
		location.href=lnk;
	}
}
// 更新序列
function UpdateSerialNO(ARCOSItemRowid,SerNO)
{	
	 var rtn=tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO)
	 return rtn	
}

// 增加医嘱套明细
function IAdd(AddType,Id,AddAmount){
	var ARCOSRowid="",ItemQty=1,DHCDocOrdRecLoc="",flag;
	
	obj=document.getElementById("ARCOSRowid");  // 医嘱套ID
	if (obj.value!="") { ARCOSRowid=obj.value; }
	
	// 判断医嘱套中是否有该医嘱
	flag = tkMakeServerCall("web.DHCPE.OrderSets","IsHaveItemInOrdSets",ARCOSRowid,Id);
	if(flag==1) { alert("该项目已存在，请勿重复添加");return false; }
	
	var SampleId=tkMakeServerCall("web.DHCPE.OrderSets","GetDefLabSpecId",Id);  // 标本
	
	var ret=tkMakeServerCall("web.DHCPE.OrderSets","GetItemLocIdAndUOMId",Id);   // 0 单位   1 接收科室

	var myStr = ret.split("^");
	DHCDocOrdRecLoc=myStr[1];
	if (DHCDocOrdRecLoc == "") {
		if(!confirm("该项目没有接收科室，确认添加？")) return false;
	}

	var ret = tkMakeServerCall("web.DHCARCOrdSets","InsertItem",ARCOSRowid,Id,1,"","","","","","","",3,SampleId,"","",DHCDocOrdRecLoc)
	//alert(ret);
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.List&ARCOSRowid="+ARCOSRowid+"&QueryFlag=1";
	location.href=lnk;
	return ret;
}

function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEOrdSets_List');	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	var obj,Data="";
	ItemMap.clear();
	
	obj=document.getElementById("ARCOSRowid");  // 医嘱套ID
	if (obj.value!="") { ARCOSRowid=obj.value; }
	else { alert("没有选择医嘱套");return false; }

	var ItemInfo=tkMakeServerCall("web.DHCPE.OrderSets","GetItemDesc",ARCOSRowid);  // 获取医嘱套明细名称
	var Char_1=String.fromCharCode(1);
	var Char_2=String.fromCharCode(2);
	var ItemInfo=ItemInfo.split(Char_1);
	if (ItemInfo!=""){
		var i=ItemInfo.length;
		for (var j=0;j<i;j++){
			var ItemDescArr=ItemInfo[j].split(Char_2);
			var ItemDesc=ItemDescArr[0];
			var ItemFlag=ItemDescArr[1];
			if ((ItemMap.get(ItemDesc)==null)&&(ItemDesc!="")) ItemMap.put(ItemDesc,ItemFlag);
		}
	}
}

function Map() {
    this.elements = new Array();

    //获取MAP元素个数
    this.size = function() {
        return this.elements.length;
    };

    //判断MAP是否为空
    this.isEmpty = function() {
        return (this.elements.length < 1);
    };

    //删除MAP所有元素
    this.clear = function() {
        this.elements = new Array();
    };

    //向MAP中增加元素（key, value)
    this.put = function(_key, _value) {
        this.elements.push( {
            key : _key,
            value : _value
        });
    };

    //删除指定KEY的元素，成功返回True，失败返回False
    this.remove = function(_key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //获取指定KEY的元素值VALUE，失败返回NULL
    this.get = function(_key) {
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    return this.elements[i].value;
                }
            }
        } catch (e) {
            return null;
        }
    };

    //获取指定索引的元素（使用element.key，element.value获取KEY和VALUE），失败返回NULL
    this.element = function(_index) {
        if (_index < 0 || _index >= this.elements.length) {
            return null;
        }
        return this.elements[_index];
    };

    //判断MAP中是否含有指定KEY的元素
    this.containsKey = function(_key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //判断MAP中是否含有指定VALUE的元素
    this.containsValue = function(_value) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //获取MAP中所有VALUE的数组（ARRAY）
    this.values = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].value);
        }
        return arr;
    };

    //获取MAP中所有KEY的数组（ARRAY）
    this.keys = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].key);
        }
        return arr;
    };
}

document.body.onload = BodyLoadHandler;
