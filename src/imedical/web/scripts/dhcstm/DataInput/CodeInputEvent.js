function deleteDetail(grid){
	 var selectedarr = grid.getSelectionModel().getSelections();
     if (selectedarr == "") { 
	        Msg.info("warning","没有选中行!");
	         return;
	    };
		if(selectedarr.length>0){
			grid.getStore().remove(selectedarr);
			grid.getView().refresh();
		}
	};
function clearData(grid){
	var rowCount = grid.getStore().getCount();
	if (rowCount==0) 
		{
			Msg.info("warning","没有需要清除的数据!");
			return ;
	   }
	 grid.getStore().removeAll();
	 grid.getView().refresh();
	};

function saveDetail(){
	var listData="";
	var rowCount = CodeGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++){
		var rowData = CodeGrid.getStore().getAt(i);
		var data="";
		var catgrp = rowData.get("catgrp");
		var stkcat = rowData.get("stkcat");
		var code = rowData.get("code");
		var desc = rowData.get("desc");
		var spec = rowData.get("spec");
		
		var brand = rowData.get("brand");
		var abbr = rowData.get("abbr");
		var alias = rowData.get("alias");
		var buom = rowData.get("buom");
		var puom = rowData.get("puom");
		
		var factor = rowData.get("factor");
		var sp = rowData.get("sp");
		var rp = rowData.get("rp");
		var charge = rowData.get("charge");
		var highvalue = rowData.get("highvalue");
		
		var batrequired = rowData.get("batrequired");
		var expdaterequired = rowData.get("expdaterequired");
		var vendor = rowData.get("vendor");
		var manf = rowData.get("manf");
		var registerno = rowData.get("registerno");
		
		var registerexpdate = rowData.get("registerexpdate");
		var businesslicense = rowData.get("businesslicense");
		var businesscertificate = rowData.get("businesscertificate");
		var businesscertificateexpdate = rowData.get("businesscertificateexpdate");
		var productionlicense = rowData.get("productionlicense");
		
		var productionlicenseexpdate = rowData.get("productionlicenseexpdate");
		var authorizationdate = rowData.get("authorizationdate");
		var contactperson = rowData.get("contactperson");
		var contacttel = rowData.get("contacttel");
		var remarks = rowData.get("remarks");
		
		data=catgrp+"^"+stkcat+"^"+code+"^"+desc+"^"+spec+"^"+
		     brand+"^"+abbr+"^"+alias+"^"+buom+"^"+ puom+"^"+
		     factor+"^"+sp+"^"+rp+"^"+charge+"^"+highvalue+"^"+
		     batrequired+"^"+expdaterequired+"^"+vendor+"^"+manf+"^"+registerno+"^"+
		     registerexpdate+"^"+businesslicense+"^"+businesscertificate+"^"+ businesscertificateexpdate+"^"+productionlicense+"^"+
		     productionlicenseexpdate+"^"+authorizationdate+"^"+contactperson+"^"+contacttel+"^"+remarks
		
		if(listData==""){
			listData=data
			}
		else{
			listData=listData+xRowDelim()+data;
			}
	}
	if (listData==""){
			Msg.info("warning","没有需要上传的数据");
			return;						
		}
	var mask=ShowLoadMask(Ext.getBody(),"上传中请稍候...");
	var url = URL+"?actiontype=SaveCode";
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params: {listData:listData},
		waitMsg : '保存中...',
		success : function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			mask.hide();
			if (jsonData.success == 'true'){
				var ret=jsonData.info;
				var arr=ret.split("^");
				var commitno=parseInt(arr[0]);
				var successno=parseInt(arr[1]);
				var defaultno=commitno-successno;
				if(commitno==successno){
					Msg.info("success","保存成功!");
					}else{
						Msg.info("warning","共"+commitno+"条数据"+"导入成功"+successno+"数据"+"导入失败"+defaultno+"数据");
						}
				}
			},
		failure: function(resp,opts){
			alert("服务器出现异常!!");
			}
		})
	};	
	
function SaveInci(){
	var rowCount = ArcCodeGrid.getStore().getCount();
	var data=""
	var listData=""
	for (var i = 0; i < rowCount; i++){
		var rowData = ArcCodeGrid.getStore().getAt(i);
		
		var catgrp = rowData.get("catgrp");
		var stkcat = rowData.get("stkcat");
		var code = rowData.get("code");
		var desc = rowData.get("desc");
		var spec = rowData.get("spec");
		
		var brand = rowData.get("brand");
		var abbr = rowData.get("abbr");
		var alias = rowData.get("alias");
		var buom = rowData.get("buom");
		var puom = rowData.get("puom");
		
		var factor = rowData.get("factor");
		var feeuom = rowData.get("feeuom");
		var sp = rowData.get("sp");
		var rp = rowData.get("rp");
		var ordcat = rowData.get("ordcat");
		
		var ordsubcat = rowData.get("ordsubcat");
		var billcat = rowData.get("billcat");
		var billsubcat = rowData.get("billsubcat");
		var tarcat = rowData.get("tarcat");
		var tarsubcat = rowData.get("tarsubcat");
		
		var inpacat = rowData.get("inpacat");
		var inpasubcat = rowData.get("inpasubcat");
		var outpacat = rowData.get("outpacat");
		var outpasubcat = rowData.get("outpasubcat");
		var emcat = rowData.get("emcat");
		
		var emsubcat = rowData.get("emsubcat");
		var acctcat = rowData.get("acctcat");
		var acctsubcat = rowData.get("acctsubcat");
		var mrcat = rowData.get("mrcat");
		var mrsubcat = rowData.get("mrsubcat");
		
		var mrsubcatnew = rowData.get("mrsubcatnew");
		var insucode = rowData.get("insucode");
		var insudesc = rowData.get("insudesc");
		var priority = rowData.get("priority");
		var onitsown = rowData.get("onitsown");
		
		var wostock = rowData.get("wostock");
		var charge = rowData.get("charge");
		var highvalue = rowData.get("highvalue");
		var batrequired = rowData.get("batrequired");
		var expdaterequired = rowData.get("expdaterequired");
		
		var supervision = rowData.get("supervision");
		var barcode = rowData.get("barcode");
		var pbflag = rowData.get("pbflag");
		var pbrp = rowData.get("pbrp");
		var vendor = rowData.get("vendor");
		
		var manf = rowData.get("manf");
		var carrier = rowData.get("carrier");
		var registerno = rowData.get("registerno");
		var registerexpdate = rowData.get("registerexpdate");
		var productionlicense = rowData.get("productionlicense");
		
		var productionlicenseexpdate = rowData.get("productionlicenseexpdate");
		var businesslicense = rowData.get("businesslicense");
		var businesslicensedate = rowData.get("businesslicensedate");
		var revreg = rowData.get("revreg");
		var orgcode = rowData.get("orgcode");
		
		var orgcodedate = rowData.get("orgcodedate");
		var businesscertificate = rowData.get("businesscertificate");
		var businesscertificateexpdate = rowData.get("businesscertificateexpdate");
		var authorizationdate = rowData.get("authorizationdate");
		var contactperson = rowData.get("contactperson");
		
		var contacttel = rowData.get("contacttel");
		var remarks = rowData.get("remarks");
		
		var data=catgrp+"^"+stkcat+"^"+code+"^"+desc+"^"+spec+"^"+
		         brand+"^"+abbr+"^"+alias+"^"+buom+"^"+puom+"^"+
		         factor+"^"+feeuom+"^"+rp+"^"+sp+"^"+ordcat+"^"+
		         ordsubcat+"^"+billcat+"^"+billsubcat+"^"+tarcat+"^"+tarsubcat+"^"+
		         inpacat+"^"+inpasubcat+"^"+outpacat+"^"+outpasubcat+"^"+emcat+"^"+
		         emsubcat+"^"+acctcat+"^"+acctsubcat+"^"+mrcat+"^"+mrsubcat+"^"+
		         mrsubcatnew+"^"+insucode+"^"+insudesc+"^"+priority+"^"+onitsown+"^"+
		         wostock+"^"+charge+"^"+highvalue+"^"+batrequired+"^"+expdaterequired+"^"+
		         supervision+"^"+barcode+"^"+pbflag+"^"+pbrp+"^"+vendor+"^"+
		         manf+"^"+carrier+"^"+registerno+"^"+registerexpdate+"^"+productionlicense+"^"+
		         productionlicenseexpdate+"^"+businesslicense+"^"+businesslicensedate+"^"+revreg+"^"+orgcode+"^"+
		         orgcodedate+"^"+businesscertificate+"^"+businesscertificateexpdate+"^"+authorizationdate+"^"+contactperson+"^"+
		         contacttel+"^"+remarks		

		if(listData==""){
			listData=data
			}
		else{
			listData=listData+xRowDelim()+data;
			}
	}
	if (listData==""){
			Msg.info("warning","没有需要上传的数据");
			return;						
		}
	var mask=ShowLoadMask(Ext.getBody(),"上传中请稍候...");
	var url = URL+"?actiontype=SaveArmCode";
	alert(listData)
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params: {listData:listData},
		waitMsg : '保存中...',
		success : function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			mask.hide();
			if (jsonData.success == 'true'){
				var ret=jsonData.info;
				var arr=ret.split("^");
				var commitno=parseInt(arr[0]);
				var successno=parseInt(arr[1]);
				var defaultno=commitno-successno;
				if(commitno==successno){
					Msg.info("success","保存成功!");
					}else{
						Msg.info("warning","共"+commitno+"条数据"+"导入成功"+successno+"数据"+"导入失败"+defaultno+"数据");
						}
				}
			},
		failure: function(resp,opts){
			alert("服务器出现异常!!");
			}
		})	
	};