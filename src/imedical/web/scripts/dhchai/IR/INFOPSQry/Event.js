function InitINFOPSQryWinEvent(obj){	
	CheckSpecificKey();	
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //��Ⱦ��ѡ��|��ѡť	
	layer.config({  
		extend: 'layerskin/style.css' 
	});	
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}
	$("#cboHospital").change(function(){
		$("#cboOperLocS").data("param",$.form.GetValue("cboHospital"));
		$.form.SelectRender("cboOperLocS");
	});
	/*****��������*****/
	$("#btnsearch").on('click', function(){
	   $('#gridINFOPSQry').DataTable().search($('#search').val(),true,true).draw();
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridINFOPSQry.search(this.value).draw();
	    }
	});
	/****************/
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		if(DateFrom > DateTo){
			layer.msg('��ʼ����ӦС�ڻ���ڽ������ڣ�');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			layer.msg('��ѡ��ʼ���ڡ��������ڣ�');
			return;
		}
		obj.gridINFOPSQry.ajax.reload(function ( json ) {
		    if (json.data.length==0){
				layer.msg('û���ҵ�������ݣ�',{time: 2000,icon: 2});
				return;
			}
			else
			{
				$("#gridINFOPSQry").dataTable().fnAdjustColumnSizing();
			}
		});
	});
	
     //����
    $("#btnExport").on('click', function () {
		obj.gridINFOPSQry.buttons(0,null)[1].node.click();
	});
    /*
 	//��ӡ
    $("#btnPrint").on('click', function(){
	    obj.gridINFOPSQry.buttons(0,null)[2].node.click();
		
	});
	*/
	obj.gridINFOPSQry.on('dblclick', 'tr', function(e) {
		var rd = obj.gridINFOPSQry.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	new $.fn.dataTable.Buttons(obj.gridINFOPSQry, {
		buttons: [
			{
				extend: 'csv',
				text:'����'
			},
			{
				extend: 'excel',
				text:'����',
				title:"�����пڵ��鱨���б�"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
					/*,format: {
	                    body: function ( data, row, column, node ) {
	                        if(data.toString().startsWith("0")){
	                            return "\0" + data;
	                        }else {
		                    	return data.replace(/<[^>]+>/g, ""); 
		                    }
	                    }
	                }*/
				},
				customize: function( xlsx ) {
					var sheet = xlsx.xl.worksheets['sheet.xml'];
					
				}
			},
			{
				extend: 'print',
				text:'��ӡ'
				,title:""
				,footer: true
			}
		]
	});
	
	obj.Layer = function(){
		$("#cboInfPos").attr('disabled','disabled');
	    $('#chkIsOperInf + .iCheck-helper').click(function(){
		    $.form.SetValue("cboInfPos","","");
			if ($("#chkIsOperInf").parent().hasClass("checked")){
				$("#cboInfPos").removeAttr("disabled");
			}else {
				$("#cboInfPos").attr('disabled','disabled');
			}
		});
	  	$.form.SelectRender("cboOperType");
	  	$.form.SelectRender("cboIncision");
	  	$.form.SelectRender("cboHealing");
	  	$.form.SelectRender("cboAnesMethod");
	  	$.form.SelectRender("cboASAScore");
	  	$.form.SelectRender("cboInfPos");
	  	$.form.SelectRender("cboNNISLevel");
		
		var rd = obj.layer_rd;
		obj.EpisodeID = rd["PAAdmDr"];
		obj.ReportID  = rd["ReportID"]; // ��Ⱦ����id
		var RepStatus = rd["RepStatus"];
		
		//ˢ�¿�����ҩ�б�
		obj.refreshgridINFAnti();
		
		$.form.SetValue("txtRegNo",rd["PapmiNo"]);
		$.form.SetValue("txtName",rd["PatName"]);
		$.form.SetValue("txtSex",rd["Sex"]);
		$.form.SetValue("txtAge",rd["Age"]);
		$.form.SetValue("txtAdmDate",rd["AdmDate"]);
		$.form.SetValue("txtDischDate",rd["DischDate"]);
		$.form.SetValue("txtMrNo",rd["MrNo"]);
        $.form.SetValue("txtBed",rd["AdmBed"]);
        $.form.SetValue("txtDiagnose",rd["MRDiagnos"]);
		
        $.form.SetValue("txtOperDesc",rd["OperName"]);
        $.form.SetValue("txtOpertorName",rd["OpertorName"]);
        $.form.DateTimeRender1('txtSttDateTime',rd["OperDate"]+" "+rd["SttTime"]);
        $.form.DateTimeRender1("txtEndDateTime",rd["EndDate"]+" "+rd["EndTime"]);
		$('#cboOperType').val(rd["OperTypeID"]).select2();
		$('#cboAnesMethod').val(rd["AnesthID"]).select2();
		$('#cboIncision').val(rd["CuteTypeID"]).select2();
		$('#cboHealing').val(rd["HealID"]).select2();
		$('#cboASAScore').val(rd["ASAID"]).select2();
		$('#cboNNISLevel').val(rd["NNISID"]).select2();
		$.form.SetValue("txtORWBC",rd["PreoperWBC"]);
		$.form.SetValue("txtInciNum",rd["CuteNumber"]);
		$.form.SetValue("txtBloodLoss",rd["BloodLoss"]);
		$.form.SetValue("txtBloodTrans",rd["BloodTrans"]);
		$.form.SetValue("chkAntiFlag",rd["PreoperAntiFlag"]== 1); // ��ǰ�ڷ�������
		$.form.SetValue("chkSightGlass",rd["EndoscopeFlag"]== 1);
		$.form.SetValue("chkImplants",rd["ImplantFlag"]== 1);
		$.form.SetValue("chkInHospInf",rd["IsInHospInf"]== 1);    // �Ƿ�Ժ��
		$.form.SetValue("chkIsOperInf",rd["IsOperInf"]== 1);      // �Ƿ��пڸ�Ⱦ
		if (rd["IsOperInf"]== 1){
			$("#cboInfPos").removeAttr("disabled");
		}
		$('#cboInfPos').val(rd["InfTypeID"]).select2();           // ��Ⱦ��λ
		var OperCompList = rd["PostoperCompsListID"];             // ����֢
        for (var indx=0;indx<OperCompList.split(",").length-1;indx++) { 
        	var OperComp = OperCompList.split(",")[indx];
            $("#"+OperComp).iCheck('check');
    	}
	        
	    layer.open({
			type: 1,
			zIndex: 100,
			skin: 'btn-all-blue',
			area: ['80%','99%'],
			title: '�����пڵ����', 
			//maxmin: true, 
			content: $('#layer_one'),
			btn: ['����','�ύ','���','ɾ��'],
			btnAlign: 'c',
			yes: function(index, layero){ // ����
		 		var ret = obj.Layer_Save("1");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridINFOPSQry,"INFOPSID",ret);
						if (rowIndex > -1){
							var rd =obj.gridINFOPSQry.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('����ɹ�!',{time: 2000,icon: 1});
					},false);
					return false;
				}
				else
				{
					layer.msg('����ʧ��!',{icon: 2});
					return false;
				}
			},
			btn2: function(index, layero){ // �ύ
				var ret = obj.Layer_Save("2");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridINFOPSQry,"INFOPSID",ret);
						if (rowIndex > -1){
							var rd =obj.gridINFOPSQry.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('�ύ�ɹ�!',{time: 2000,icon: 1});
					},false);				
				}
				else
				{
					layer.msg('�ύʧ��!',{icon: 2});
					return false;
				}				  	
			},
			btn3: function(index, layero){ // ���
				var ret = obj.Layer_Save("3");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridINFOPSQry,"INFOPSID",ret);
						if (rowIndex > -1){
							var rd =obj.gridINFOPSQry.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('��˳ɹ�!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('���ʧ��!',{icon: 2});
					return false;
				}	
			},
			btn4: function(index, layero){ // ɾ��
				var ret = obj.Layer_Save("4");
			  	if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						layer.msg('ɾ���ɹ�!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('ɾ��ʧ��!',{icon: 2});
					return false;
				}	
			},
			success: function(layero){
				var button0 = layero.find(".layui-layer-btn0"); //����
				var button1 = layero.find(".layui-layer-btn1"); //�ύ
				var button2 = layero.find(".layui-layer-btn2"); //���
				var button3 = layero.find(".layui-layer-btn3"); //ɾ��
				if (!RepStatus) {
					$(button2).hide();
					$(button3).hide();
				}else if (RepStatus =='����') {
					$(button2).hide();
				}else if (RepStatus =='�ύ') {
					$(button0).hide();
					if (CheckFlg !='1') {
						$(button2).hide();
					}
				}else if (RepStatus =='���') {
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					if (CheckFlg !='1') {
						$(button3).hide();
					}
				}else if (RepStatus =='ɾ��') {
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					$(button3).hide();
				}
			}
		});	
	}
	// �����пڵ��鱨��
    $('#gridINFOPSQry').on('click','a.btnReport', function (e) {
	  
	    $("#cboInfPos").attr("disabled","disabled");
	    $('#chkIsOperInf + .iCheck-helper').click(function(){
		    $.form.SetValue("cboInfPos","","");
			if ($("#chkIsOperInf").parent().hasClass("checked")){
				$("#cboInfPos").removeAttr("disabled");
			}else {
				$("#cboInfPos").attr('disabled','disabled');
			}
		});
	  	$.form.SelectRender("cboOperType");
	  	$.form.SelectRender("cboIncision");
	  	$.form.SelectRender("cboHealing");
	  	$.form.SelectRender("cboAnesMethod");
	  	$.form.SelectRender("cboASAScore");
	  	$.form.SelectRender("cboInfPos");
	  	$.form.SelectRender("cboNNISLevel");
		var tr = $(this).closest('tr');
		var row = obj.gridINFOPSQry.row(tr);
		var rd = row.data();
		obj.layer_rd = rd;
		obj.EpisodeID = rd["PAAdmDr"];
		obj.ReportID  = rd["ReportID"]; // ��Ⱦ����id
		obj.refreshgridINFAnti();
		
		var RepStatus = rd["RepStatus"];
		$.form.SetValue("txtRegNo",rd["PapmiNo"]);
		$.form.SetValue("txtName",rd["PatName"]);
		$.form.SetValue("txtSex",rd["Sex"]);
		$.form.SetValue("txtAge",rd["Age"]);
		$.form.SetValue("txtAdmDate",rd["AdmDate"]);
		$.form.SetValue("txtDischDate",rd["DischDate"]);
		$.form.SetValue("txtMrNo",rd["MrNo"]);
        $.form.SetValue("txtBed",rd["AdmBed"]);
        $.form.SetValue("txtDiagnose",rd["MRDiagnos"]);
		
        $.form.SetValue("txtOperDesc",rd["OperName"]);
        $.form.SetValue("txtOpertorName",rd["OpertorName"]);
        $.form.DateTimeRender1('txtSttDateTime',rd["OperDate"]+" "+rd["SttTime"]);
        $.form.DateTimeRender1("txtEndDateTime",rd["EndDate"]+" "+rd["EndTime"]);
		$('#cboOperType').val(rd["OperTypeID"]).select2();
		$('#cboAnesMethod').val(rd["AnesthID"]).select2();
		$('#cboIncision').val(rd["CuteTypeID"]).select2();
		$('#cboHealing').val(rd["HealID"]).select2();
		$('#cboASAScore').val(rd["ASAID"]).select2();
		$('#cboNNISLevel').val(rd["NNISID"]).select2();
		$.form.SetValue("txtORWBC",rd["PreoperWBC"]);
		$.form.SetValue("txtInciNum",rd["CuteNumber"]);
		$.form.SetValue("txtBloodLoss",rd["BloodLoss"]);
		$.form.SetValue("txtBloodTrans",rd["BloodTrans"]);
		$.form.SetValue("chkAntiFlag",rd["PreoperAntiFlag"]== 1); // ��ǰ�ڷ�������
		$.form.SetValue("chkSightGlass",rd["EndoscopeFlag"]== 1);
		$.form.SetValue("chkImplants",rd["ImplantFlag"]== 1);
		$.form.SetValue("chkInHospInf",rd["IsInHospInf"]== 1);    // �Ƿ�Ժ��
		$.form.SetValue("chkIsOperInf",rd["IsOperInf"]== 1);      // �Ƿ��пڸ�Ⱦ
		if (rd["IsOperInf"]== 1){
			$("#cboInfPos").removeAttr("disabled");
		}
		$('#cboInfPos').val(rd["InfTypeID"]).select2();           // ��Ⱦ��λ
		var OperCompList = rd["PostoperCompsListID"];             // ����֢
        for (var indx=0;indx<OperCompList.split(",").length-1;indx++) { 
        	var OperComp = OperCompList.split(",")[indx];
            $("#"+OperComp).iCheck('check');
    	}
	        
	    layer.open({
			type: 1,
			zIndex: 100,
			skin: 'btn-all-blue',
			area: ['80%','99%'],
			title: '�����пڵ����', 
			//maxmin: true, 
			content: $('#layer_one'),
			btn: ['����','�ύ','���','ɾ��'],
			btnAlign: 'c',
			yes: function(index, layero){ // ����
		 		var ret = obj.Layer_Save("1");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridINFOPSQry,"INFOPSID",ret);
						if (rowIndex > -1){
							var rd =obj.gridINFOPSQry.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('����ɹ�!',{time: 2000,icon: 1});
					},false);
					return false;
				}
				else
				{
					layer.msg('����ʧ��!',{icon: 2});
					return false;
				}
			},
			btn2: function(index, layero){ // �ύ
				var ret = obj.Layer_Save("2");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridINFOPSQry,"INFOPSID",ret);
						if (rowIndex > -1){
							var rd =obj.gridINFOPSQry.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('�ύ�ɹ�!',{time: 2000,icon: 1});
					},false);
				}
				else
				{
					layer.msg('�ύʧ��!',{icon: 2});
					return false;
				}				  	
			},
			btn3: function(index, layero){ // ���
				var ret = obj.Layer_Save("3");
				if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						layer.msg('��˳ɹ�!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('���ʧ��!',{icon: 2});
					return false;
				}	
			},
			btn4: function(index, layero){ // ɾ��
				var ret = obj.Layer_Save("4");
			  	if(parseInt(ret)>0)
				{
					obj.gridINFOPSQry.ajax.reload(function(){
						layer.msg('ɾ���ɹ�!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('ɾ��ʧ��!',{icon: 2});
					return false;
				}	
			},
			success: function(layero){
				var button0 = layero.find(".layui-layer-btn0"); //����
				var button1 = layero.find(".layui-layer-btn1"); //�ύ
				var button2 = layero.find(".layui-layer-btn2"); //���
				var button3 = layero.find(".layui-layer-btn3"); //ɾ��
				if (!RepStatus) {
					$(button2).hide();
					$(button3).hide();
				}else if (RepStatus =='����') {
					$(button2).hide();
				}else if (RepStatus =='�ύ') {
					$(button0).hide();
					if (CheckFlg !='1') {
						$(button2).hide();
					}
				}else if (RepStatus =='���') {
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					$(button3).hide();  //����˵ı��治��ɾ��
				}else if (RepStatus =='ɾ��') {
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					$(button3).hide();
				}
			}
		});
    });
    obj.Layer_Save =function(Status) {
	    var rd = obj.layer_rd;
	    var ReportID         = rd["ReportID"];      // ����ID
	    var INFOPSID         = rd["INFOPSID"];      // �����пڼ�¼ID
		var PAAdmDr          = rd["PAAdmDr"];       // �����¼
		var IRRepType        = "4";                 // �������ͣ������пڵ����
		var IRRepDate        = rd["RepDate"];       // ��������
		var IRRepTime        = rd["RepTime"];       // ����ʱ��
		var IRRepLocDr       = $.LOGON.LOCID;       // ������ң�����Ӧ�������ң�rd["OperLocID"]��
		var IRRepUser        = $.LOGON.USERID;      // ������
		var IRStatusDr       = Status;              // ����״̬ ��ID
		var IRLinkDiags      = "";                  // ��Ⱦ���
		var IRLinkICDs       = "";                  // �������
		var IRLinkLabs       = "";                  // ��ԭѧ�ͼ�
		var IRLinkAntis      = "";                  // ������ҩ
		var IRLinkOPSs       = INFOPSID;            // ������Ϣ
		var IRLinkMRBs       = "";                  // ������Ϣ
		var IRLinkInvOpers   = "";                  // �ֺ��Բ���
		var IRLinkICUUCs     = "";                  // ICU�����
		var IRLinkICUVAPs    = "";                  // ICU������
		var IRLinkICUPICCs   = "";                  // ICU���ľ���
		var IRDiagnosisBasis = "";                  // �������
		var IRDiseaseCourse  = "";                  // ��Ⱦ�Լ�������
		var IRInLocDr        = "";                  // �����Դ
		var IROutLocDr       = "";                  // ����ȥ��
		var IRInDate         = "";                  // ���ʱ��
		var IROutDate        = "";                  // ����ʱ�� 
		var IRAPACHEScore    = "";                  // APACHE������
		var IROutIntubats    = "";                  // ת��ICU�������
		var IROut48Intubats  = "";                  // ת��ICU48�������
		
	    var AnaesID       = rd["AnaesDR"];                      // ������¼ID
	    var OperLocDR     = rd["OperLocID"];                    // ��������
	    var OperDxDr      = rd["OperDxDr"];                     // ��׼����ID
	    var OperDesc      = $.form.GetValue("txtOperDesc");     // ��������
		var StartDateTime = $.form.GetValue("txtSttDateTime");  // ��ʼ����ʱ��
			StartDateTime = StartDateTime.replace(" ","")
	    var StartDate     = StartDateTime.substring(0,10);      // ��ʼ����
	    var StartTime     = StartDateTime.substring(10,15);     // ��ʼʱ��
	    var EndDateTime   = $.form.GetValue("txtEndDateTime");  // ��������ʱ��
			EndDateTime   = EndDateTime.replace(" ","")
	    var EndDate       = EndDateTime.substring(0,10);        // ��������
	    var EndTime       = EndDateTime.substring(10,15);       // ����ʱ��
	    var OpertorName   = $.form.GetValue("txtOpertorName");  // ����ҽ��
	    var OperTypeDR    = $.form.GetValue("cboOperType");     // ��������
	    var AnesMethodDR  = $.form.GetValue("cboAnesMethod");   // ����ʽ
	    var IncisionDR    = $.form.GetValue("cboIncision");     // �пڵȼ�
	    var HealingDR     = $.form.GetValue("cboHealing");      // �������
	    var NNISLevelDR   = $.form.GetValue("cboNNISLevel");    // NNIS�ּ�
	    var ASAScoreDR    = $.form.GetValue("cboASAScore");     // ASA����
	    var InfPosDR      = $.form.GetValue("cboInfPos");       // ��Ⱦ��λ
	    var ORWBC         = $.form.GetValue("txtORWBC");        // ��ǰ����WBC
	    var InciNum       = $.form.GetValue("txtInciNum");      // �пڸ���
	    var BloodLoss     = $.form.GetValue("txtBloodLoss");    // ʧѪ��
	    var BloodTrans    = $.form.GetValue("txtBloodTrans");   // ��Ѫ��
	    var AntiFlag      = $.form.GetValue("chkAntiFlag");     // ��ǰ�ڷ�������
	    var SightGlass    = $.form.GetValue("chkSightGlass");   // �Ƿ�ʹ�ÿ���
	    var Implants      = $.form.GetValue("chkImplants");     // ֲ����
	    var InHospInf     = $.form.GetValue("chkInHospInf");    // �Ƿ�����Ժ��
	    var IsOperInf     = $.form.GetValue("chkIsOperInf");    // �пڸ�Ⱦ
        var OperCompList  = "";                                 // ����֢����ֵ���ŷָ���
        $('input:checkbox',$("#chkOperComp")).each(function(){
       		if(true == $(this).is(':checked')){
            	OperCompList+=$(this).attr("id")+",";
       		}
    	});
    	
		// ������Ϣ
		var InputRepStr = ReportID;  // ����ID DHCHAI.IR.INFReport
		InputRepStr += "^" + PAAdmDr;
		InputRepStr += "^" + IRRepType;
		InputRepStr += "^" + IRRepDate;
		InputRepStr += "^" + IRRepTime;
		InputRepStr += "^" + IRRepLocDr;
		InputRepStr += "^" + IRRepUser; 
		InputRepStr += "^" + IRStatusDr;
		InputRepStr += "^" + IRLinkDiags;
		InputRepStr += "^" + IRLinkICDs;
		InputRepStr += "^" + IRLinkLabs;
		InputRepStr += "^" + IRLinkAntis;
		InputRepStr += "^" + IRLinkOPSs;
		InputRepStr += "^" + IRLinkMRBs;
		InputRepStr += "^" + IRLinkInvOpers;
		InputRepStr += "^" + IRLinkICUUCs;
		InputRepStr += "^" + IRLinkICUVAPs;
		InputRepStr += "^" + IRLinkICUPICCs;
		InputRepStr += "^" + IRDiagnosisBasis;
		InputRepStr += "^" + IRDiseaseCourse;
		InputRepStr += "^" + IRInLocDr;
		InputRepStr += "^" + IRInDate;
		InputRepStr += "^" + IROutDate;
		InputRepStr += "^" + IRAPACHEScore;  
		InputRepStr += "^" + IROutIntubats; 
		InputRepStr += "^" + IROut48Intubats; 
		
		// �����пڵ��鱨����Ϣ
    	var InputOPSStr = INFOPSID;
		InputOPSStr += "^" + PAAdmDr;
		InputOPSStr += "^" + AnaesID;
		InputOPSStr += "^" + OperLocDR;
		InputOPSStr += "^" + OperDesc;
		InputOPSStr += "^" + OperDxDr;
		InputOPSStr += "^" + StartDate;
		InputOPSStr += "^" + EndDate;
		InputOPSStr += "^" + StartTime;
		InputOPSStr += "^" + EndTime;
		InputOPSStr += "^" + "";         // ����ʱ��
		InputOPSStr += "^" + OpertorName;
		InputOPSStr += "^" + "";         //����ҽ��DR
		InputOPSStr += "^" + OperTypeDR;
		InputOPSStr += "^" + AnesMethodDR;
		InputOPSStr += "^" + NNISLevelDR;
		InputOPSStr += "^" + IncisionDR;
		InputOPSStr += "^" + HealingDR;
		InputOPSStr += "^" + IsOperInf;
		InputOPSStr += "^" + InfPosDR;
		InputOPSStr += "^" + InHospInf;
		InputOPSStr += "^" + ASAScoreDR;
		InputOPSStr += "^" + ORWBC;
		InputOPSStr += "^" + InciNum;
		InputOPSStr += "^" + SightGlass;
		InputOPSStr += "^" + Implants;
		InputOPSStr += "^" + AntiFlag;
		InputOPSStr += "^" + BloodLoss;
		InputOPSStr += "^" + BloodTrans;
		InputOPSStr += "^" + OperCompList;
	    InputOPSStr += "^" + "";   // ��������
	    InputOPSStr += "^" + "";   // ����ʱ��
	    InputOPSStr += "^" + $.LOGON.USERID;
		
	    // ��־��Ϣ
	    var InputLogStr = "";            // DHCHAI.IR.INFReport-->ID
		InputLogStr += "^" + Status;     // ״̬
	    InputLogStr += "^" + "";         // �������
	    InputLogStr += "^" + $.LOGON.USERID;
		
	    // ����ҩ����Ϣ
	    var InputAnti=obj.ANT_Save();
	    
	    var InputStr = InputOPSStr+"#"+InputRepStr+"#"+InputLogStr+"#"+InputAnti;
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.INFOPSSrv","SaveINFOPS",InputStr);
		return retval;
    }
    
   //------------����ҩ����Ϣ--------------//
   function refreshgridINFAntiSync(){
		if(obj.gridINFAntiSync==undefined)
		{
			obj.gridINFAntiSync = $("#gridINFAntiSync").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep";
						d.Arg1 = '';
						d.Arg2 = obj.EpisodeID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
				]
			});
			obj.gridINFAntiSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFAntiSync.row(this).data();
				if (typeof(data)=='undefined') return;
				layer.close(layer.index);
				OpenINFAntiEdit(data,'');
			});
		}else{
			obj.gridINFAntiSync.ajax.reload(function(){});
		}
	}
	refreshgridINFAntiSync();
	// ��������ҩ����ȡ��
	function OpenINFAntiSync(){
		refreshgridINFAntiSync();
		obj.LayerOpenINFAntiSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "������ҩ-��ȡ[˫�����ݽ��б༭]", 
				area: '75%',
				content: $('#LayerOpenINFAntiSync')
		});	
	}
	// ��������ҩ��༭��
	function OpenINFAntiEdit(d,r){
		obj.LayerOpenINFAntiEdit = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "������ҩ-�༭", 
				area: ['700px',''],
				content: $('#LayerOpenINFAntiEdit'),
				btnAlign: 'c',
				btn: ['����','ȡ��'],
				yes: function(index, layero){
				  	// �������
					INFAntiAdd(d,r);
				}
				,success: function(layero){
					InitINFAntiEditData(d,r);
				}
		});	
	}
	
	function INFAntiAdd(d,r){
		var ID = '';
		var AntiUseID = '';
		var AntiDesc2 = '';
		if (d){
			ID = d.ID;
			AntiUseID = d.AntiUseID;
			AntiDesc2 = d.AntiDesc2;
		}
		var AntiDesc = $.form.GetText("cboAnti");
		var DoseQty = $.form.GetValue("txtDoseQty");
		var DoseUnitID = $.form.GetValue("cboDoseUnit");
		if (DoseUnitID==''){
			var DoseUnit='';
		}else{
			var DoseUnit = $.form.GetText("cboDoseUnit");
		}
		var PhcFreqID = $.form.GetValue("cboPhcFreq");
		if (PhcFreqID==''){
			var PhcFreq='';
		}else{
			var PhcFreq = $.form.GetText("cboPhcFreq");
		}
		var MedUsePurposeID = $.form.GetValue("cboMedUsePurpose");
		if (MedUsePurposeID==''){
			var MedUsePurpose='';
		}else{
			var MedUsePurpose = $.form.GetText("cboMedUsePurpose");
		}
		var AdminRouteID = $.form.GetValue("cboAdminRoute");
		if (AdminRouteID==''){
			var AdminRoute='';
		}else{
			var AdminRoute = $.form.GetText("cboAdminRoute");
		}
		var MedPurposeID = $.form.GetValue("cboMedPurpose");
		if (MedPurposeID==''){
			var MedPurpose='';
		}else{
			var MedPurpose = $.form.GetText("cboMedPurpose");
		}
		var TreatmentModeID = $.form.GetValue("cboTreatmentMode");
		if (TreatmentModeID==''){
			var TreatmentMode='';
		}else{
			var TreatmentMode = $.form.GetText("cboTreatmentMode");
		}	
		var PreMedEffectID = $.form.GetValue("cboPreMedEffect");
		if (PreMedEffectID==''){
			var PreMedEffect='';
		}else{
			var PreMedEffect = $.form.GetText("cboPreMedEffect");
		}	
		var PreMedIndicatID = $.form.GetValue("cboPreMedIndicat");
		if (PreMedIndicatID==''){
			var PreMedIndicat='';
		}else{
			var PreMedIndicat = $.form.GetText("cboPreMedIndicat");
		}
		var CombinedMedID = $.form.GetValue("cboCombinedMed");
		if (CombinedMedID==''){
			var CombinedMed='';
		}else{
			var CombinedMed = $.form.GetText("cboCombinedMed");
		}
		var SttDate = $.form.GetValue("txtSttDate");
		var EndDate = $.form.GetValue("txtEndDate");
		var PreMedTime = $.form.GetValue("txtPreMedTime");
		var PostMedDays = $.form.GetValue("txtPostMedDays");
		var SenAnaID = $.form.GetValue("cboSenAna");
		if (SenAnaID==''){
			var SenAna='';
		}else{
			var SenAna = $.form.GetText("cboSenAna");
		}
		if (($.form.GetValue("cboAnti")=='')&&(AntiDesc=='--��ѡ��--')){
    		layer.msg('ҽ��������Ϊ��!',{icon: 2});
			return;
    	}
    	if (DoseQty==''){
    		layer.msg('��������Ϊ��!',{icon: 2});
			return;
    	}
    	if (DoseUnit==''){
    		layer.msg('������λ����Ϊ��!',{icon: 2});
			return;
    	}
    	if (PhcFreq==''){
    		layer.msg('Ƶ�β���Ϊ��!',{icon: 2});
			return;
    	}
		if (MedUsePurpose==''){
    		layer.msg('��;����Ϊ��!',{icon: 2});
			return;
    	}
    	if (AdminRoute==''){
    		layer.msg('��ҩ;������Ϊ��!',{icon: 2});
			return;
    	}
    	if (MedPurpose==''){
    		layer.msg('Ŀ�Ĳ���Ϊ��!',{icon: 2});
			return;
    	}
    	if (TreatmentMode==''){
    		layer.msg('������ҩ��ʽ����Ϊ��!',{icon: 2});
			return;
    	}
    	if (PreMedEffect==''){
    		layer.msg('Ԥ����ҩЧ������Ϊ��!',{icon: 2});
			return;
    	}
    	if (PreMedIndicat==''){
    		layer.msg('Ԥ����ҩָ�벻��Ϊ��!',{icon: 2});
			return;
    	}
    	if (CombinedMed==''){
    		layer.msg('������ҩ����Ϊ��!',{icon: 2});
			return;
    	}
    	if (SttDate==''){
    		layer.msg('��ʼ���ڲ���Ϊ��!',{icon: 2});
			return;
    	}
    	if (EndDate==''){
    		layer.msg('�������ڲ���Ϊ��!',{icon: 2});
			return;
    	}
		if (!$.form.CompareDate(EndDate,SttDate)){
			layer.msg('�������ڲ����ڿ�ʼ����֮ǰ!',{icon: 2});
			return;
		}
		var row ={
			'ID'              : ID,
			'EpisodeID'       : obj.EpisodeID,
			'ReportID'        : obj.ReportID,
			'AntiUseID'       : AntiUseID,
			'AntiDesc'        : AntiDesc,
			'AntiDesc2'       : AntiDesc2,
			'SttDate'         : SttDate,
			'EndDate'         : EndDate,
			'DoseQty'         : DoseQty,
			'DoseUnitID'      : DoseUnitID,
			'DoseUnit'        : DoseUnit,
			'PhcFreqID'       : PhcFreqID,
			'PhcFreq'         : PhcFreq,
			'MedUsePurposeID' : MedUsePurposeID,
			'MedUsePurpose'   : MedUsePurpose,
			'AdminRouteID'    : AdminRouteID,
			'AdminRoute'      : AdminRoute,
			'MedPurposeID'    : MedPurposeID,
			'MedPurpose'      : MedPurpose,
			'TreatmentModeID' : TreatmentModeID,
			'TreatmentMode'   : TreatmentMode,
			'PreMedEffectID'  : PreMedEffectID,
			'PreMedEffect'    : PreMedEffect,
			'PreMedIndicatID' : PreMedIndicatID,
			'PreMedIndicat'   : PreMedIndicat,
			'CombinedMedID'   : CombinedMedID,
			'CombinedMed'     : CombinedMed,
			'PreMedTime'      : PreMedTime,
			'PostMedDays'     : PostMedDays,
			'SenAnaID'        : SenAnaID,
			'SenAna'          : SenAna,
			'UpdateDate'      : '',
			'UpdateTime'      : '',
			'UpdateUserID'    : $.LOGON.USERID,
			'UpdateUser'      : ''
		}

		// �����ظ���־
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFAnti.data().length;i++){
    		if (r) {
    			if ($(r).context._DT_RowIndex==i){
    				continue;
    			}
    		}
    		if ((AntiDesc==obj.gridINFAnti.data()[i].AntiDesc)&&(SttDate==obj.gridINFAnti.data()[i].SttDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.confirm('���ڿ�ʼ���ڡ���������ͬ�ļ�¼,�Ƿ���ӿ�������Ϣ��', {
			  btn: ['��','��'] //��ť
			}, function(){
				InsertAnti(r,row);
			});
    	}else{
    		InsertAnti(r,row);
    	};
	}

	function InsertAnti(r,row){
		if (r){  //�޸�
			var rowIndex = $(r).context._DT_RowIndex; //�к�
			obj.gridINFAnti.row(r).data(row).draw();
		}else{	//���
			obj.gridINFAnti.row.add(row).draw();
		}
		// �رյ��� 
       	layer.close(layer.index);
	}

	function InitINFAntiEditData(d,r){
		// ��Ⱦ�ؼ�
		$.form.SelectRender('cboDoseUnit');
		$.form.SelectRender('cboPhcFreq');
		$.form.SelectRender('cboMedUsePurpose');
		$.form.SelectRender('cboAdminRoute');
		$.form.SelectRender('cboMedPurpose');
		$.form.SelectRender('cboTreatmentMode');
		$.form.SelectRender('cboPreMedEffect');
		$.form.SelectRender('cboPreMedIndicat');
		$.form.SelectRender('cboCombinedMed');
		$.form.SelectRender('cboSenAna');
		$.form.SelectRender('cboAnti');
		// �ؼ���ֵ
		if (d){
			$.form.DateRender('txtSttDate',d.SttDate,'top-right');
			$.form.DateRender('txtEndDate',d.EndDate,'top-right');
			$.form.SetValue('cboAnti','',d.AntiDesc);
			$.form.SetValue('txtDoseQty',d.DoseQty);
			$.form.SetValue('cboDoseUnit',d.DoseUnitID,d.DoseUnit);
			$.form.SetValue('cboPhcFreq',d.PhcFreqID,d.PhcFreq);
			$.form.SetValue('cboMedUsePurpose',d.MedUsePurposeID,d.MedUsePurpose);
			$.form.SetValue('cboAdminRoute',d.AdminRouteID,d.AdminRoute);
			$.form.SetValue('cboMedPurpose',d.MedPurposeID,d.MedPurpose);
			$.form.SetValue('cboTreatmentMode',d.TreatmentModeID,d.TreatmentMode);
			$.form.SetValue('cboPreMedEffect',d.PreMedEffectID,d.PreMedEffect);
			$.form.SetValue('cboPreMedIndicat',d.PreMedIndicatID,d.PreMedIndicat);
			$.form.SetValue('cboCombinedMed',d.CombinedMedID,d.CombinedMed);
			$.form.SetValue('cboSenAna',d.SenAnaID,d.SenAna);
			$.form.SetValue('txtPreMedTime',d.PreMedTime);
			$.form.SetValue('txtPostMedDays',d.PostMedDays);
		}else{
			$.form.DateRender('txtSttDate','','top-right');
			$.form.DateRender('txtEndDate','','top-right');
			$.form.SetValue('cboAnti','','');
			$.form.SetValue('txtDoseQty','');
			$.form.SetValue('cboDoseUnit','','');
			$.form.SetValue('cboPhcFreq','','');
			$.form.SetValue('cboMedUsePurpose','','');
			$.form.SetValue('cboAdminRoute','','');
			$.form.SetValue('cboMedPurpose','','');
			$.form.SetValue('cboTreatmentMode','','');
			$.form.SetValue('cboPreMedEffect','','');
			$.form.SetValue('cboPreMedIndicat','','');
			$.form.SetValue('cboCombinedMed','','');
			$.form.SetValue('cboSenAna','','');
			$.form.SetValue('txtPreMedTime','');
			$.form.SetValue('txtPostMedDays','');
		}
	}
	// ��ӿ���ҩ���¼�
	$("#btnINFAntiAdd").click(function(e){
		OpenINFAntiEdit('','');
	});
	// ����ҩ����ȡ�¼�
	$('#btnINFAntiSync').click(function(e){
		// TODOͬ��ҽ��
		//$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncHisInfo','SyncAdmOEOrdItem',HISCode,EpisodeIDx,ServiceDate,ServiceDate);
		OpenINFAntiSync();
	});
	// ɾ������ҩ���¼�
	$("#btnINFAntiDel").click(function(e){
		var selectedRows = obj.gridINFAnti.rows({selected: true}).count();
		if (selectedRows!== 1 ) {
			layer.msg('��ѡ��һ������!',{icon: 2});
			return;
		}else{
			var rd = obj.gridINFAnti.rows({selected: true}).data().toArray()[0];
			layer.confirm('�Ƿ�ɾ��������ҩ��'+rd.AntiDesc+'��', {
			  btn: ['��','��'] //��ť
			}, function(){
				obj.gridINFAnti.rows({selected:true}).remove().draw(false);
				layer.msg('ɾ��������ҩ�ɹ���', {icon: 1});
			});
			// obj.gridINFAnti.rows({selected:true}).remove().draw(false);
		}
	});
	// ����ҩ����Ϣ�б�˫���¼�
	obj.gridINFAnti.on('dblclick', 'tr', function(e) {
		var data  = obj.gridINFAnti.row(this).data();
		if (typeof(data)=='undefined') return;
		OpenINFAntiEdit(data,this);
	});

	obj.ANT_Save = function(){
		// ����ҩ��
    	var InputAnti = '';
    	for (var i=0;i<obj.gridINFAnti.data().length;i++){
    		var Input = obj.gridINFAnti.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiUseID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiDesc;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiDesc2;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].SttDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].EndDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].DoseQty;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].DoseUnitID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PhcFreqID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].MedUsePurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AdminRouteID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].MedPurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].TreatmentModeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedEffectID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedIndicatID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].CombinedMedID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedTime;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PostMedDays;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].SenAnaID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		InputAnti = InputAnti + CHR_2 + Input;
    	}
    	if (InputAnti) InputAnti = InputAnti.substring(1,InputAnti.length);
    	return InputAnti;
	} 
	
	//������ƽӿ�
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//�Ƿ������ֵ���ռ�飨true��������
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="";  // ����ID�б�
		$('#gridINFOPSQry tbody .icheckbox_square-blue').each(function(){
			if ($(this).hasClass("checked")){
				//var tmpRepID = $(this).parent().next().text();
				var tr = $(this).closest("tr");
				var row = obj.gridINFOPSQry.row(tr);
				var rd = row.data();
				var tmpRepID = rd["ReportID"];
				if (tmpRepID!="") {
					RepIDs +=  "^"+tmpRepID;
				} 
			}
		});
		RepIDs=RepIDs.substring(1);
		if (RepIDs == "") {
			layer.msg('��ѡ����Ҫ�����ı���!',{icon: 2});
			return;
		}
		var arrList = RepIDs.split("^");
		ExtTool.RunQuery(
			{
				ClassName : 'DHCHAI.MK.ExportToMKSrv',
				QueryName : 'QryValidateInfo',
				Arg1 : RepIDs,
				Arg2 : "^",
				Arg3 : "1",
				ArgCnt : 3
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrm = new InitwinProblem(RepIDs, "^",obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("�ļ�·��", "��������ƽӿ��ļ����·��...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//����������
								Ext.MessageBox.progress("�ӿ��ļ�", "��ʼ������ƽӿ��ļ�...");
								var intTotalCnt = arrList.length;
								var flag = 0;
								for(var indRec = 0; indRec < intTotalCnt; indRec++)
								{
									var repID = arrList[indRec];
									var repInfo = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv","GetReportInfo",repID);
									var PatName = repInfo.split("^")[0];
									var PatMrNo = repInfo.split("^")[1];
									var PatAdmDate = repInfo.split("^")[2];
									var strfolderName = PatMrNo + " " + PatName + " " + PatAdmDate;
									var strPath = ExportPath + "\\" + strfolderName;
									var ret = objExportMinke.ExportMinkeData(repID, strPath,RepIDs);
									if(ret==false){   //�ж��Ƿ���δ��˵ı���
										flag++;
										continue;
									}
									//���½�����
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "���ڴ���" + PatMrNo + " " + PatName);
									
								}
								
								//�رս�����
								Ext.MessageBox.hide();
								if(flag==intTotalCnt){   //�ȹرս���������ʾ
									layer.msg('δ��˱���',{icon:2});
									return;	
								}
								ExtTool.confirm("�ӿ��ļ�", "��������" + intTotalCnt + "�ݻ��߸�Ⱦ������Ϣ,�Ƿ���ļ�����ļ���!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
							}
						},
						null,
						false,
						"D:\\��Ƹ�Ⱦ����ӿ��ļ�"
					)
				}
			}
			,obj
			,skipMapping
		)
	};
	$("#btnExportMK").on('click', function () {
		obj.btnExportInterface_click();	
	});
	
    $(".checkall + .iCheck-helper").click(function(){
		if ($(".checkall + .iCheck-helper").parent().attr("class").indexOf("checked")>=0){
			$('#gridINFOPSQry tbody .icheckbox_square-blue').addClass("checked");
		}
		else{
			$('#gridINFOPSQry tbody .icheckbox_square-blue').removeClass("checked");
		}
	});
	$('#gridINFOPSQry tbody').on('click', '.icheckbox_square-blue', function(){
    	if(!$(this).hasClass('checked')){
	    	// ѡ��
	    	//var tmpRepID = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			$(".checkall + .iCheck-helper").parent().addClass("checked");
			$('#gridINFOPSQry tbody .icheckbox_square-blue').each(function(){
				if (!$(this).hasClass("checked")){
					$(".checkall + .iCheck-helper").parent().removeClass("checked");
				}
			});
			
    	}else{
	    	// ȡ��
			$(this).removeClass("checked");
			$(".checkall + .iCheck-helper").parent().removeClass("checked");	
	    }
    });
}

function getContentSize() {
    var wh = document.documentElement.clientHeight; 
    var eh = 166;
    var ch = (wh - eh) + "px";
    obj = document.getElementById("mCSB_1");
    var dh=$('div.dataTables_scrollHead').height();
    var sh=(wh - eh + dh )+ "px"; 
    if (obj){  
   		obj.style.height = ch;
    }else {
	   $('div.dataTables_scrollBody').css('height',sh);
    }
}