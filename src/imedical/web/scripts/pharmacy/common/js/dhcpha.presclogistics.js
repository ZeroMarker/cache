//imedical/web/scripts/pharmacy/common/js/dhcpha.presclogistics.js
//��������
//��ʼ��ʡ
var gUserId = DHCPHA_CONSTANT.SESSION.GUSER_ROWID ;
var pprowidN = ""
function InitProvince(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetProvinceList&style=select2",
		allowClear:true,
	 	placeholder:'ʡ...'
		}
	$("#sel-province").dhcphaSelect(selectoption)
	$('#sel-province').on('select2:select', function (event) { 
		provId=$("#sel-province").val();
		InitCity(provId)
	});
	
	}
//��ʼ����
function InitCity(provId){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetCityList&style=select2&provId="+provId,
		allowClear:true,
	 	placeholder:'��...'
		}
	$("#sel-city").dhcphaSelect(selectoption)
	$('#sel-city').on('select2:select', function (event) { 
		//alert(event)
		var cityrowid=$('#sel-city').val();
		InitCityArea(cityrowid);
	});
	}
//��ʼ����
function InitCityArea(cityrowid){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetCityAreaList&style=select2&cityrowid="+cityrowid,
		allowClear:true,
	 	placeholder:'��...'
		}
	$("#sel-cityarea").dhcphaSelect(selectoption)
	$('#sel-cityarea').on('select2:select', function (event) { 
		//alert(event)
	});
}

//��ʼ��ȡҩ��ʽ
function InitPrescTakeMode(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPrescTakeModeStore&style=select2",
		allowClear:true,
	 	placeholder:'ȡҩ��ʽ'
		}
	$("#sel-prescTakeMode").dhcphaSelect(selectoption)
	$('#sel-prescTakeMode').on('select2:select', function (event) { 
		//alert(event)
	});
}

//��ʼ����ҩʱ��
function InitTime(){
	var data = [
	 { id: 1, text: 'ȫ��' }, 
	 { id: 2, text: '����' },
     { id: 3, text: '����' }, 
     { id: 4, text: '����' },
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

//��ʼ���෽����
function InitTaboo(){
	var data = [
	 { id: 0, text: '��' }, 
	 { id: 1, text: '�ɾ�' },
     { id: 2, text: '����' }, 
     { id: 3, text: '�ɾ�,��' },
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
//��ʼ����װ����
function InitPackMaterial(){
	var data = [
	 { id: 1, text: '��װ' }, 
	 { id: 2, text: '����Ĥ' }
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
///��ʼ����ʷ�ʼĵ�ַ
function InitGirdAddress(){
	var columns=[
		{header:'provinceId',index:'provinceId',name:'provinceId',width:100,hidden:true},
	    {header:'ʡ',index:'provinceDesc',name:'provinceDesc',width:80},
	    {header:'cityId',index:'cityId',name:'cityId',width:100,hidden:true},
		{header:'��',index:'cityDesc',name:'cityDesc',width:80},
		{header:'areaId',index:'areaId',name:'areaId',width:100,hidden:true},
		{header:'��/��',index:'areaDesc',name:'areaDesc',width:100},
		{header:'��ϸ��ַ',index:'address',name:'address',width:180},
		{header:'��ϵ�绰',index:'phoneNo',name:'phoneNo',width:100},
		{header:'phdaId',index:'phdaId',name:'phdaId',width:100,hidden:true},
		{header:'����',index:'opeater',name:'opeater',width:80,hidden:true,
			formatter:function(cellvalue,options,rowObject){
		        		return "<a href='#' onclick='DeleteAddress(\""+rowObject.phdaId+"\")'><i style='color:red'>ɾ��</i></a>";
		        }},
	]; 
	var jqOptions={
	    colModel: columns, //��
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
			$("#sel-province").append(provinceoption); //��Ĭ��ֵ
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
		    dhcphaMsgBox.alert("û��ѡ������,���ܷ�ҩ!");
		    return;
		}
		var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
		var prescno=selrowdata.TPrescNo;
	}else if(type=="2"){
		var selectid=$("#grid-presclist").jqGrid('getGridParam','selrow');
		if (selectid==null){
		    dhcphaMsgBox.alert("û��ѡ������,���ܷ�ҩ!");
		    return;
		}
		var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
		var prescno=selrowdata.TPrescNo;
		}
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("����ϵ����ʦ��֤�����Ƿ��������!");
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
	$('#txt-delivery-prescno').val(prescno); //���͵�ַ
	//$('#txt-delivery-address').val(DeliveryAddress); //���͵�ַ
	if(DeliveryDate==""){
		$('#date-delivery').val(FormatDateT("t+1"));	//��������
	}else{
		$('#date-delivery').val(DeliveryDate);	//��������
		}
	if(Timedesc == undefined){Timedesc="";}
	var timeoption = '<option value='+"'"+Time +"'"+'selected>'+Timedesc+'</option>'
	$("#sel-time").append(timeoption);
	$("#txt-receiver").val(receiver);
	$("#txt-phone").val(phone);
	//��ȡ���ͷ�ʽ New 202104-2   ���ز���Ҫ��
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
	
	//��ȡ��ַ��Ϣ
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
	$("#sel-province").append(provinceoption); //��Ĭ��ֵ
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

///�������Ϣ��ȷ��
function DeliverySure(prescno,type)
{			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("����ϵ����ʦ��֤�����Ƿ��������!");
		return;
	}
	var DeliveryAddress=$('#txt-delivery-address').val(); //���͵�ַ
	var DeliveryDate=$('#date-delivery').val();	//��������
	var Time=$('#sel-time').val();  //����ʱ��
	
	var takePrescMode = $("#sel-prescTakeMode").val();		// ȡҩ��ʽ
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
	//��ȡ��ַ�б�
	var provinceDr=$("#sel-province").val();
	var cityDr=$("#sel-city").val();
	var cityAreaDr=$("#sel-cityarea").val();
	if((provinceDr=="")||(provinceDr=="null")||(cityDr=="")||(cityDr=="null")||(cityAreaDr=="")||(cityAreaDr=="null")||(DeliveryAddress=="")||(DeliveryAddress=="null")||(DeliveryDate=="")||(DeliveryDate=="null")||(receiver=="")||(receiver=="null")||(phone=="")||(phone=="null")){
		dhcphaMsgBox.alert("����֤������Ϣ������");
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
		dhcphaMsgBox.alert('����������Ϣʧ�ܣ�'+ErrMsg);
		return;
	}
	else{
		if(type=="1"){
			ExecuteFY();
		}else if(type=="2"){
			ConfirmDisp();
		}
		/*
		var prt=""; //���ô�����̨ȡ
		var params="O"+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+prescno+"^"+prt;
		var retval=tkMakeServerCall("web.DHCSTInterfacePH","SendCYPrescInfo",params); 
		var retarr=retval.split("^")
		var ErrCode=retarr[0];
		var ErrMsg=retarr[1];
		if(ErrCode!="0"){
			dhcphaMsgBox.alert('�������ͳɹ�,����������Ϣʧ��:'+ErrMsg);
			return;
		}  
		*/ 
	}
	$('#modal-delivery').modal('hide');	
	pprowidN="";
	return;
}

///�������Ϣ��ȷ��
function DeliveryCancel()
{
	ClearDeliveryInfo();
	$('#modal-delivery').modal('hide');	
	$("#txt-cardno").focus();
	return false;
}

function ClearDeliveryInfo()
{
	$('#txt-delivery-prescno').val(""); //���͵�ַ	
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
	$("#sel-province").append(provinceoption); //��Ĭ��ֵ
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

// ɾ���ʼĵ�ַ��ʷ
function DeleteAddress(phdaRowId)
{
	if ((phdaRowId==null)||(phdaRowId=="")){
	    dhcphaMsgBox.alert("û��ѡ������!");
	    return;
	}	
	var deleteret=tkMakeServerCall("PHA.IN.DeliveryAddress.Save","DeleteAddress",phdaRowId)
	QueryAddress(prescnoQuery)
}

/// ˢ���ʼĵ�ַ��Ϣ
function FreshAddress()
{
	QueryAddress(prescnoQuery)
}