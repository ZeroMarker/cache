//imedical/web/scripts/pharmacy/common/js/dhcpha.presclogistics.js
//处方物流
//初始化省
var gUserId = DHCPHA_CONSTANT.SESSION.GUSER_ROWID ;
var pprowidN = ""
function InitProvince(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetProvinceList&style=select2",
		allowClear:true,
	 	placeholder:'省...'
		}
	$("#sel-province").dhcphaSelect(selectoption)
	$('#sel-province').on('select2:select', function (event) { 
		provId=$("#sel-province").val();
		InitCity(provId)
	});
	
	}
//初始化市
function InitCity(provId){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetCityList&style=select2&provId="+provId,
		allowClear:true,
	 	placeholder:'市...'
		}
	$("#sel-city").dhcphaSelect(selectoption)
	$('#sel-city').on('select2:select', function (event) { 
		//alert(event)
		var cityrowid=$('#sel-city').val();
		InitCityArea(cityrowid);
	});
	}
//初始化区
function InitCityArea(cityrowid){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetCityAreaList&style=select2&cityrowid="+cityrowid,
		allowClear:true,
	 	placeholder:'区...'
		}
	$("#sel-cityarea").dhcphaSelect(selectoption)
	$('#sel-cityarea').on('select2:select', function (event) { 
		//alert(event)
	});
}

//初始化取药方式
function InitPrescTakeMode(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPrescTakeModeStore&style=select2",
		allowClear:true,
	 	placeholder:'取药方式'
		}
	$("#sel-prescTakeMode").dhcphaSelect(selectoption)
	$('#sel-prescTakeMode').on('select2:select', function (event) { 
		//alert(event)
	});
}

//初始化送药时段
function InitTime(){
	var data = [
	 { id: 1, text: '全天' }, 
	 { id: 2, text: '上午' },
     { id: 3, text: '下午' }, 
     { id: 4, text: '晚上' },
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:true
	};
	$("#sel-time").dhcphaSelect(selectoption);
	$('#sel-time').on('select2:select', function (event) { 
		//Query();
	})	
		
}

//初始化膏方禁忌
function InitTaboo(){
	var data = [
	 { id: 0, text: '无' }, 
	 { id: 1, text: '忌酒' },
     { id: 2, text: '忌糖' }, 
     { id: 3, text: '忌酒,糖' },
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      //minimumResultsForSearch: Infinity
	};
	$("#sel-taboo").dhcphaSelect(selectoption);
	$('#sel-taboo').on('select2:select', function (event) { 
		//Query();
	})	
		
}
//初始化包装材料
function InitPackMaterial(){
	var data = [
	 { id: 1, text: '罐装' }, 
	 { id: 2, text: '复合膜' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      //minimumResultsForSearch: Infinity
	};
	$("#sel-packmaterial").dhcphaSelect(selectoption);
	$('#sel-packmaterial').on('select2:select', function (event) { 
		//Query();
	})			
}
///初始化历史邮寄地址
function InitGirdAddress(){
	var columns=[
		{header:'provinceId',index:'provinceId',name:'provinceId',width:100,hidden:true},
	    {header:'省',index:'provinceDesc',name:'provinceDesc',width:80},
	    {header:'cityId',index:'cityId',name:'cityId',width:100,hidden:true},
		{header:'市',index:'cityDesc',name:'cityDesc',width:80},
		{header:'areaId',index:'areaId',name:'areaId',width:100,hidden:true},
		{header:'区/县',index:'areaDesc',name:'areaDesc',width:100},
		{header:'详细地址',index:'address',name:'address',width:180},
		{header:'联系电话',index:'phoneNo',name:'phoneNo',width:100},
		{header:'phdaId',index:'phdaId',name:'phdaId',width:100,hidden:true},
		{header:'操作',index:'opeater',name:'opeater',width:80,hidden:true,
			formatter:function(cellvalue,options,rowObject){
		        		return "<a href='#' onclick='DeleteAddress(\""+rowObject.phdaId+"\")'><i style='color:red'>删除</i></a>";
		        }},
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=GetAddressList&style=jqGrid',	
	    height: 200,
	    shrinkToFit:false,
	    datatype:'local',
	    onSelectRow:function(id,status){
		    var selrowdata = $(this).jqGrid('getRowData', id);
			var provinceId = selrowdata.provinceId
			var provinceDesc = selrowdata.provinceDesc
			var cityId = selrowdata.cityId
			var cityDesc = selrowdata.cityDesc
			var areaId = selrowdata.areaId
			var areaDesc = selrowdata.areaDesc
			var address = selrowdata.address
			var phoneNo = selrowdata.phoneNo
			pprowidN = selrowdata.phdaId
			var provinceoption = '<option value='+"'"+provinceId +"'"+'selected>'+provinceDesc+'</option>'
			$("#sel-province").append(provinceoption); //设默认值
			if(cityDesc == undefined){cityDesc="";}
			var cityoption = '<option value='+"'"+cityId +"'"+'selected>'+cityDesc+'</option>'
			$("#sel-city").append(cityoption);
			if(areaDesc == undefined){areaDesc="";}
			var cityAreaoption = '<option value='+"'"+areaId +"'"+'selected>'+areaDesc+'</option>'
			$("#sel-cityarea").append(cityAreaoption);
			$('#txt-delivery-address').val(address);
			$('#txt-phone').val(phoneNo);
		}
	};
	$("#grid-address").dhcphaJqGrid(jqOptions);
}
function ShowDeliveryWin(type)
{
	if(type=="1"){
		var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
		if (selectid==null){
		    dhcphaMsgBox.alert("没有选中数据,不能发药!");
		    return;
		}
		var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
		var prescno=selrowdata.TPrescNo;
	}else if(type=="2"){
		var selectid=$("#grid-presclist").jqGrid('getGridParam','selrow');
		if (selectid==null){
		    dhcphaMsgBox.alert("没有选中数据,不能发药!");
		    return;
		}
		var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
		var prescno=selrowdata.TPrescNo;
		}
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("请联系工程师验证程序是否存在问题!");
		return;
	}

	//sel-prescTakeMode
	
	var retval=tkMakeServerCall("PHA.HERB.PrescLogistics.Query","GetLogisticsInfo",prescno);
	var retarr=retval.split("^")
	var DeliveryAddress=retarr[0];
	var DeliveryDate=retarr[1];
	var DJPost=retarr[2];
	var DJNotPost=retarr[3];
	var DPPost=retarr[4];
	var DPNotPost=retarr[5];
	var Time=retarr[7];
	var Timedesc=retarr[8];
	var receiver=retarr[9];
	var phone=retarr[10];
	if(receiver==""){
		var prescnoInfo = tkMakeServerCall("PHA.HERB.PrescLogistics.Query","GetPrescInfoStr",prescno);
		var mainInfo=prescnoInfo.split("^")
		var receiver=mainInfo[0];
		var phone=mainInfo[1];
		}
	var taboo=retarr[11];
	var taboodesc=retarr[12];
	var packMaterial=retarr[13];
	var packMaterialdesc=retarr[14];
	var isprocess=retarr[15];
	var cashandmatch=retarr[17];
	if(DeliveryAddress == undefined){DeliveryAddress="";}
	if(DeliveryDate == undefined){DeliveryDate="";}
	$('#txt-delivery-prescno').val(prescno); //配送地址
	//$('#txt-delivery-address').val(DeliveryAddress); //配送地址
	if(DeliveryDate==""){
		$('#date-delivery').val(FormatDateT("t+1"));	//配送日期
	}else{
		$('#date-delivery').val(DeliveryDate);	//配送日期
		}
	if(Timedesc == undefined){Timedesc="";}
	var timeoption = '<option value='+"'"+Time +"'"+'selected>'+Timedesc+'</option>'
	$("#sel-time").append(timeoption);
	$("#txt-receiver").val(receiver);
	$("#txt-phone").val(phone);
	//获取配送方式 New 202104-2   隐藏不需要的
	var postTypeStr = tkMakeServerCall("PHA.HERB.Com.Method","GetPostType",prescno);
	var posttypeData = postTypeStr.split("^")
	var posttypeId = posttypeData[0] ;
	var posttypeDesc = posttypeData[2] ;
	if(posttypeDesc == undefined){posttypeDesc="";}
	var postTypeoption = '<option value='+"'"+posttypeId +"'"+'selected>'+posttypeDesc+'</option>'
	$("#sel-prescTakeMode").append(postTypeoption);

	if(taboodesc == undefined){taboodesc="";}
	var taboooption = '<option value='+"'"+taboo +"'"+'selected>'+taboodesc+'</option>'
	$("#sel-tatoo").append(taboooption);
	if(packMaterialdesc == undefined){packMaterialdesc="";}
	var packoption = '<option value='+"'"+packMaterial +"'"+'selected>'+packMaterialdesc+'</option>'
	$("#sel-packmaterial").append(packoption)
	if(isprocess="Y"){$("#chk-isprocess").iCheck("check")}
	
	//获取地址信息
	var addressret=tkMakeServerCall("web.DHCINPHA.PrescLogistics","getPatAddressbyPrescNo",prescno);
	var addressarr=addressret.split("^")
	var provinceId=addressarr[0];
	var provincedesc=addressarr[1];
	var cityId=addressarr[2];
	var citydesc=addressarr[3];
	var cityAreaId=addressarr[4];
	var cityAreadesc=addressarr[5];
	var address=addressarr[6];
	var provinceoption = '<option value='+"'"+provinceId +"'"+'selected>'+provincedesc+'</option>'
	$("#sel-province").append(provinceoption); //设默认值
	if(citydesc == undefined){citydesc="";}
	var cityoption = '<option value='+"'"+cityId +"'"+'selected>'+citydesc+'</option>'
	$("#sel-city").append(cityoption);
	if(cityAreadesc == undefined){cityAreadesc="";}
	var cityAreaoption = '<option value='+"'"+cityAreaId +"'"+'selected>'+cityAreadesc+'</option>'
	$("#sel-cityarea").append(cityAreaoption);
	$('#txt-delivery-address').val(address);
	QueryAddress(prescno);
	$("#modal-delivery").modal('show');
}

///填报配送信息后确认
function DeliverySure(prescno,type)
{			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("请联系工程师验证程序是否存在问题!");
		return;
	}
	var DeliveryAddress=$('#txt-delivery-address').val(); //配送地址
	var DeliveryDate=$('#date-delivery').val();	//配送日期
	var Time=$('#sel-time').val();  //配送时段
	
	var takePrescMode = $("#sel-prescTakeMode").val();		// 取药方式
	console.log(takePrescMode)
	if ((takePrescMode == 1)||(takePrescMode == "")||(takePrescMode == 0)){
		if(type=="1"){
			ExecuteFY();
		}else if(type=="2"){
			ConfirmDisp();
		}
		$('#modal-delivery').modal('hide');	
		pprowidN="";
		return;	
	}
	var phaLocId=session['LOGON.CTLOCID'];
	var receiver=$("#txt-receiver").val();
	var phone=$("#txt-phone").val();
	var taboo=$("#sel-taboo").val();
	var packmaterial=$("#sel-packmaterial").val();
	var isprocess="N";
	if( $("#chk-isprocess").is(':checked') ){
			isprocess="Y";
		}
	var remark=$("#txt-delivery-remark").val()
	//获取地址列表
	var provinceDr=$("#sel-province").val();
	var cityDr=$("#sel-city").val();
	var cityAreaDr=$("#sel-cityarea").val();
	if((provinceDr=="")||(provinceDr=="null")||(cityDr=="")||(cityDr=="null")||(cityAreaDr=="")||(cityAreaDr=="null")||(DeliveryAddress=="")||(DeliveryAddress=="null")||(DeliveryDate=="")||(DeliveryDate=="null")||(receiver=="")||(receiver=="null")||(phone=="")||(phone=="null")){
		dhcphaMsgBox.alert("请验证必填信息！！！");
		return;
		}
	var params = prescno+"^"+ phaLocId +"^"+ DeliveryDate +"^"+ gUserId +"^"+ takePrescMode ;
	var params = params +"^"+ taboo +"^"+ packmaterial +"^"+ isprocess +"^"+ Time +"^"+ remark;
	var params = params +"^"+ pprowidN;
	var addressParams = provinceDr +"^"+ cityDr +"^"+ cityAreaDr +"^"+ DeliveryAddress +"^"+ phone;
	var addressParams =addressParams +"^"+ receiver ;
	//DeliveryCancel()
	
	var retval=tkMakeServerCall("PHA.HERB.PrescLogistics.Save","SaveLogistics",params,addressParams); 
	if(retval<0){
		var retarr=retval.split("^")
		var ErrCode=retarr[0];
		var ErrMsg=retarr[1];
		dhcphaMsgBox.alert('保存配送信息失败：'+ErrMsg);
		return;
	}
	else{
		if(type=="1"){
			ExecuteFY();
		}else if(type=="2"){
			ConfirmDisp();
		}
		/*
		var prt=""; //不用传，后台取
		var params="O"+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+prescno+"^"+prt;
		var retval=tkMakeServerCall("web.DHCSTInterfacePH","SendCYPrescInfo",params); 
		var retarr=retval.split("^")
		var ErrCode=retarr[0];
		var ErrMsg=retarr[1];
		if(ErrCode!="0"){
			dhcphaMsgBox.alert('保存配送成功,发送配送信息失败:'+ErrMsg);
			return;
		}  
		*/ 
	}
	$('#modal-delivery').modal('hide');	
	pprowidN="";
	return;
}

///填报配送信息后确认
function DeliveryCancel()
{
	ClearDeliveryInfo();
	$('#modal-delivery').modal('hide');	
	$("#txt-cardno").focus();
	return false;
}

function ClearDeliveryInfo()
{
	$('#txt-delivery-prescno').val(""); //配送地址	
	$('#txt-delivery-address').val("");
	$('#date-delivery').val("");
	
	$("#txt-delivery-remark").val("")
	$("#txt-receiver").val("");
	$("#txt-phone").val("");
	pprowidN=""
}


function changedeliveryaddress(prescno){
	var addressret=tkMakeServerCall("web.DHCINPHA.PrescLogistics","getPatAddressbyPrescNo",prescno);
	var addressarr=addressret.split("^")
	var provinceId=addressarr[0];
	var provincedesc=addressarr[1];
	var cityId=addressarr[2];
	var citydesc=addressarr[3];
	var cityAreaId=addressarr[4];
	var cityAreadesc=addressarr[5];
	var address=addressarr[6];
	var provinceoption = '<option value='+"'"+provinceId +"'"+'selected>'+provincedesc+'</option>'
	$("#sel-province").append(provinceoption); //设默认值
	if(citydesc == undefined){citydesc="";}
	var cityoption = '<option value='+"'"+cityId +"'"+'selected>'+citydesc+'</option>'
	$("#sel-city").append(cityoption);
	if(cityAreadesc == undefined){cityAreadesc="";}
	var cityAreaoption = '<option value='+"'"+cityAreaId +"'"+'selected>'+cityAreadesc+'</option>'
	$("#sel-cityarea").append(cityAreaoption);
	$('#txt-delivery-address').val(address); 
	}
function QueryAddress(prescno)
{
	$("#grid-address").setGridParam({
		datatype:'json',
		postData:{
			'prescno':prescno
		}
	}).trigger("reloadGrid");
	prescnoQuery=prescno
}

// 删除邮寄地址历史
function DeleteAddress(phdaRowId)
{
	if ((phdaRowId==null)||(phdaRowId=="")){
	    dhcphaMsgBox.alert("没有选中数据!");
	    return;
	}	
	var deleteret=tkMakeServerCall("PHA.IN.DeliveryAddress.Save","DeleteAddress",phdaRowId)
	QueryAddress(prescnoQuery)
}

/// 刷新邮寄地址信息
function FreshAddress()
{
	QueryAddress(prescnoQuery)
}