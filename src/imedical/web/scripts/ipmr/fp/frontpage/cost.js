/**
 * 费用信息
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */
var globalObj = {
	data:{}	// 数据
}

// 页面入口
$(function(){
	renderCmp(0);
	// 保存按钮
	$('#synCost').click(function(){
		synCost();
	});
})

function synCost(){
	$m({
		ClassName:"MA.IPMR.FPS.EmrRecordSrv",
		MethodName:"getEmrData",
		aEpisodeID:ServerObj.EpisodeID,
		aFirstLetter:'F'
	},function(txtData){
		if (txtData==''){
			$.messager.alert("错误","同步失败...","error")
			return false;
		}else{
			$.messager.popover({msg: '同步成功...',type:'alert',timeout: 1000});
			renderCmp(1);
			return true;
		}
	});
}

// 加载值
function renderCmp(aEmrFlag){
	$cm({
    	ClassName:"MA.IPMR.FPS.CodeExtraSrv",
    	QueryName:"QryExtraInfo",
    	aVolumeID:'',
		aEpisodeID:ServerObj.EpisodeID,
		aFirstLetter:'F',
		aEmrFlag:aEmrFlag,
    	rows:10000
    },function(rs){
		var json = '{';
		var cmpcount=0;
    	for (i=0;i<rs.total;i++){
	    	var data = rs.rows[i];
	    	var value = data.value;
	    	var DICatCode = data.DICatCode;
	    	var DataType = data.DataType;
			var IsShowCode = data.IsShowCode;
			var LinkCatCode = data.LinkCatCode;
	    	var val = value.split('^')[0];
	    	var txt = value.split('^')[1];
			var id = value.split('^')[2];
			var cmpid = DICatCode;
	    	if ($('#'+cmpid).length==0) continue;
			$('#'+cmpid).val(txt);
			$('#'+cmpid).attr("disabled", true);
			// 数据存入baseData结构
			cmpcount++
			var cmpStr = '"'+cmpid +'":{"itemCode":"' + DICatCode + '","LinkCatCode":"' + LinkCatCode + '","id":"' + id + '","code":"' + val+ '","text":"' + txt + '","dataType":"' + DataType + '","isShowCode":"' + IsShowCode+'"}';
			if (cmpcount==1) {
				json = json + cmpStr;
			}else{
				json = json + ',' + cmpStr;
			}
	    }
		json = json + '}';
		globalObj.data = JSON.parse(json);
    });
}
// 返回保存时的数据格式
function getCostinfo(){
	var data = globalObj.data;
	
	var strResult = '';
	for(var i in data){
		var strTemp = '';
		var itemData = data[i];
		var itemCode = itemData.itemCode;
	    var id= itemData.id;
	    var code= itemData.code;
	    var text= itemData.text;
	    var dataType= itemData.dataType;
		strTemp = itemCode+'01'+CHR_1+text;
		if (strResult != '') strResult += CHR_2
		strResult += strTemp
	}
	return strResult;
}

/**
 * 编目数据项数据替换（表单和数据json）
 * @param {array} 需替换成的数据内容['cmpid',id,code,text]
 * @return {Boolean} True 正常, false 异常
 */
function replaceData(array) 
{
	try {
		var data = globalObj.data;
		for(var i in data){
			var item = data[i];
			if (item.itemCode!=array[0]) continue;
			updatedata(array[0],array[1],array[2],array[3]);
			setText(item.itemCode,item.text);
		}
	}catch(e){
		return false;
	}
	return true;
}

function updatedata(cmp,id,code,text){
	var str = 'globalObj.data.'+cmp+'.id='+'"'+id+'"';
	eval(str);
	var str = 'globalObj.data.'+cmp+'.code='+'"'+code+'"';
	eval(str);
	var str = 'globalObj.data.'+cmp+'.text='+'"'+text+'"';
	eval(str);
	var str = 'var cmpdata = globalObj.data.'+cmp;
	eval(str);
	console.log(globalObj.data)
}