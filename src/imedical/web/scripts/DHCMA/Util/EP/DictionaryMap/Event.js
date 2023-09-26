﻿//页面Event
function InitDicMapWinEvent(obj){
    obj.LoadEvent = function(args){
	    
	    $('#gridDictionary').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    $('#gridDicMap').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0

		$('#btnMapAdd').on('click', function(){
	     	obj.btnMapAdd_click();
     	});
     	$('#btnMapUpdate').on('click', function(){
	     	obj.btnMapUpdate_click();
     	});
     	$('#btnMapDelete').on('click', function(){
	     	obj.btnMapDelete_click();
     	});
     	$('#txtMapSearch').searchbox({ 
			searcher:function(value,name){ 
				obj.gridDicMapLoad(value);
			}	
		});
     	$('#txtSearch').searchbox({ 
			searcher:function(value,name){ 
				obj.gridDictionaryLoad(value);
			}	
		});
    }
	
	
	obj.gridDictionaryLoad = function(aAlias){
		$cm ({
			ClassName:"DHCMA.Util.EPS.DictionarySrv",
			QueryName:"QryDicInfo",		
			aTypeDr:$('#cboDicType').combobox('getValue'),
			aAlias:aAlias,
			rows:999
		},function(rs){
			$('#gridDictionary').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
    }
	
	obj.gridDicMapLoad = function(aAlias){
		$cm ({
			ClassName:"DHCMA.Util.BTS.DictionaryMapSrv",
			QueryName:"QryDicMap",
			aDicTypeID:$('#cboDicType').combobox('getValue'),
			aAlias:aAlias,
			page:1,
			rows:999
		},function(rs){
			$('#gridDicMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
    }
    

	//新增对照
	obj.btnMapAdd_click = function(){
		var errinfo = "";
		var rd=obj.gridDictionary.getSelected();
	    var DicDesc = rd["Desc"];
	    var DicType = rd["TypeCode"];

	    var Maprd = obj.gridDicMap.getSelected();
		var MapID = Maprd["MapID"];
		var DicID = Maprd["DicID"];
		var ProDicType = Maprd["DicType"];
		var Product = Maprd["Product"];
        var MapDicDesc = Maprd["MapDicDesc"];
        if ((MapID)&&(MapDicDesc)&&(DicDesc!=MapDicDesc)) { //已对照的项目再对照名称不同的项目，视为增加
        	MapID = "";
        }
		if ((!rd)||(!Maprd)) {
			errinfo = errinfo + "先选中字典项再对照!<br>";	
		}
		var DicTypeDr = $m({
			ClassName:"DHCMA.Util.BT.DicTypeMap",
			MethodName:"GetIdByType",
			aDicType:DicType, 
			aProduct:Product,
			aProDicType:ProDicType
		},false);
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = MapID;
		inputStr = inputStr + CHR_1 + DicDesc;
		inputStr = inputStr + CHR_1 + DicTypeDr;
		inputStr = inputStr + CHR_1 + DicID;
		inputStr = inputStr + CHR_1 + 1;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.DictionaryMap",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "新增对照数据错误!Error=" + flg, 'info');			
		}else {
			$.messager.popover({msg: '新增对照成功！',type:'success',timeout: 1000});
			obj.gridDicMapLoad() ;//刷新
		}
	}
	
	//修改对照
	obj.btnMapUpdate_click = function(){
		var errinfo = "";
		var rd=obj.gridDictionary.getSelected();
	    var DicDesc = rd["Desc"];
	    var DicType = rd["TypeCode"];

	    var Maprd = obj.gridDicMap.getSelected();
		var MapID = Maprd["MapID"];
		var DicID = Maprd["DicID"];
		var DicTypeDr = Maprd["MapDicTypeID"];
	
		if ((!rd)||(!Maprd)) {
			errinfo = errinfo + "先选中字典项再修改对照!<br>";	
		}
		if (!DicTypeDr) {
			errinfo = errinfo + "无对照项目不需修改!<br>";	
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = MapID;
		inputStr = inputStr + CHR_1 + DicDesc;
		inputStr = inputStr + CHR_1 + DicTypeDr;
		inputStr = inputStr + CHR_1 + DicID;
		inputStr = inputStr + CHR_1 + 1;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.DictionaryMap",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "修改对照数据错误!Error=" + flg, 'info');			
		}else {
			$.messager.popover({msg: '修改对照成功！',type:'success',timeout: 1000});
			obj.gridDicMapLoad() ;//刷新
		}
	}
	
	//取消对照 
	obj.btnMapDelete_click = function(){
		var Maprd = obj.gridDicMap.getSelected();
		var MapID = Maprd["MapID"];
		if (MapID=="") return;
		
		$.messager.confirm("取消对照", "是否取消选中数据对照记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.DictionaryMap",
					MethodName:"DeleteById",
					aID:MapID
				},false);           
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","取消对照错误!Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '取消对照成功！',type:'success',timeout: 1000});
					obj.gridDicMapLoad() ;//刷新
				}
			} 
		});
	}
	
		
}