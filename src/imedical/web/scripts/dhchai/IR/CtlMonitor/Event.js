function InitCtlMonitorWinEvent(obj){
	CheckSpecificKey();
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}

	/*****��������*****/
	$("#btnsearch").on('click', function(){
	   $('#gridCtlResult').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridCtlResult.search(this.value).draw();
	    }
	});
	/****************/
	obj.gridCtlResult.on('dblclick', 'tr', function(e) {
		var rowData = obj.gridCtlResult.row(this).data();
		openDetail_click(rowData);
	});
	
	//��ذ�ť
	$("#btnTask").on('click', function(){
		layer.confirm('ȷ��ִ�м������',{
			btn: ['ȷ��','ȡ��'],
			btnAlign: 'c'
		}, function(index){
			layer.close(index);
			$.Tool.ProgressBar.Start({
				title: "�������",
				tips: "��������ִ��"
			});			
			function monitorAjax(){
				$.ajax({
					url : 'dhcmed.cc.sys.ctrlrequest.csp',
					type : "POST",
					timeout: 25000,
					data  : {
						ClassName : 'DHCHAI.Task.TaskManager',
						MethodName : 'CheckBackTask2',
						Arg1 : $.form.GetCurrDate('-'),
						Arg2 : $.form.GetCurrDate('-'),
						ArgCnt : 2
					},
					success : function(response) {
						var tmpText = response;  //���������ǰ�˶���һ���ַ�
						console.log(tmpText);
						if (tmpText.indexOf('OK') > -1) {
							//ִ�����
							obj.ControlFlag = 1;
							$.Tool.ProgressBar.Update(100);
							setTimeout(function() {
								$.Tool.ProgressBar.Close();
								layer.msg('���ִ����ɣ�',{time: 2000,icon: 1});
								//ִ��Ĭ�ϲ�ѯ
								$("#DateFrom").val($.form.GetCurrDate('-'));
								$("#DateTo").val($.form.GetCurrDate('-'));
								obj.gridCtlResult.ajax.reload();
							},1000);
						} else {
							//����ִ��,���µ���
							if (parseInt(tmpText) % 50 == 0) {
								var Num=tmpText/10;		//�����������趨��ĸ����֤���Num<100����
							}
							$.Tool.ProgressBar.Update(Num);
							monitorAjax();
						}
					},error : function(XMLHttpRequest, textStatus, errorThrown) {
						console.log("Error:","XMLHttpRequest:" + JSON.stringify(XMLHttpRequest),"textStatus:" + textStatus,"errorThrown:" + errorThrown);
						$.Tool.ProgressBar.Close();
						if ((XMLHttpRequest.status == 504)||(textStatus == "timeout")) {
							layer.msg('����ʱ��������ִ�У�',{time: 2000,icon: 2});
						} else {
							layer.msg('����������������ִ�У�',{time: 2000,icon: 2});
						}
					}
				});
			}
			monitorAjax();
		});
		
	});
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
	    
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		obj.gridCtlResult.clear().draw();
		if(DateFrom > DateTo){
			layer.msg('��ʼ����ӦС�ڻ���ڽ������ڣ�',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridCtlResult.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('û���ҵ�������ݣ�',{time: 2000,icon: 2});
				return;
			}
		});
	});
     //����
    $("#btnExport").on('click', function(){
		obj.gridCtlResult.buttons(0,null)[1].node.click();
	});
    /*
 	//��ӡ
    $("#btnPrint").on('click', function(){
	    obj.gridCtlResult.buttons(0,null)[2].node.click();
		
	});
	*/
	new $.fn.dataTable.Buttons(obj.gridCtlResult, {
		buttons: [
			{
				extend: 'csv',
				text:'����'
			},
			{
				extend: 'excel',
				text:'����',
				title:"��ҩ�����"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
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
	//��ϸ���ӵ��
	openDetail_click = function(rowData) {
		obj.EpisodeID=rowData["AdmID"];
		var PatName=rowData["PatName"];
		var Sex=rowData["Sex"];
	    switch (Sex){
			case 'Ů':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
				break;
			case '��':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
			default:
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
		}
	    obj.gridBactDetail.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 100,
			offset: '80px',
			area: '900px',
			title:[imgHtml+' '+PatName]+'  ������ϸ',
			content: $('#layer_three')
		});
	}
	$('#gridCtlResult').on('click','a.detail', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
	    openDetail_click(rowData);
    });

    //ҩ���������ѡ�з�ʽ
    $('#gridCtlResult').on('click','a.btnLabSen', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
	    obj.ResultID=rowData["ResultID"];
	    var PatName=rowData["PatName"];
	    var Sex=rowData["Sex"];
	    switch (Sex){
			case 'Ů':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
				break;
			case '��':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
			default:
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
		}
	    obj.gridIRDrugSen.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 100,
			offset: '80px',
			area: '600px',
			title:[imgHtml+' '+PatName]+'  ҩ�����',
			content: $('#layer_one')
		});
	
    });
    
    //��ҩ������
    $('#gridCtlResult').on('click','a.btnReprot', function (e) {
	    $.form.CheckBoxRender();
	    $.form.iCheckRender();
		$("#txtUnitExt").attr("disabled","disabled");
		$('#chkUnitList .iCheck-helper').click(function(){
        	if($(this).parent().parent().text().indexOf("����")>=0){
	        	if(true == $(this).parent().hasClass("checked")){
		        	$("#txtUnitExt").removeAttr("disabled");
	        	}else{
		        	$("#txtUnitExt").attr("disabled","disabled");
		        }
            }
		});
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rd = row.data();
		obj.layer_rd = rd;
		$.form.SetValue("txtRegNo",rd["PapmiNo"]);
		$.form.SetValue("txtName",rd["PatName"]);
		$.form.SetValue("txtSex",rd["Sex"]);
		$.form.SetValue("txtAge",rd["Age"]);
		$.form.SetValue("txtNo",rd["MrNo"]);
        $.form.SetValue("txtAdmDate",rd["AdmDate"]);
        $.form.SetValue("txtDischDate",rd["DischDate"]);
        $.form.SetValue("txtActDate",rd["ActDate"]);
        $.form.SetValue("txtBed",rd["AdmBed"]);
        
        switch (rd["Sex"]){
			case 'Ů':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
				break;
			case '��':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
			default:
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
		}
        var ResultID=rd["ID"];
        var Flg = $.Tool.RunServerMethod("DHCHAI.IR.INFMBR","CheckIsMap",ResultID);
        if(parseInt(Flg)== '-1') {
	        layer.msg('������¼�б걾δά����׼���ƶ��գ�����ά���걾��׼����!',{time: 3000,icon: 2});
            return false;
        }else if (parseInt(Flg)== '-2') {
	        layer.msg('������¼��ϸ��δά����׼���ƶ��գ�����ά��ϸ����׼����!',{time: 3000,icon: 2});
            return false;     
        }else if (parseInt(Flg)== '-3') {
	        layer.msg('������¼��ϸ�����Ƕ�����ҩ��������ά��������ҩ������!',{time: 3000,icon: 2});
            return false;     
        }
        var InfMBRID=rd["INFMBRID"];
        var objInfo = $.Tool.RunServerMethod("DHCHAI.IRS.INFMBRSrv","GetReportString",InfMBRID);
        var RepInfo = $.Tool.RunServerMethod("DHCHAI.IRS.INFMBRSrv","GetMBRRepID",rd["AdmID"],InfMBRID)
        var RepStatus = RepInfo.split("^")[5];
        
        if(InfMBRID) {
	        var InfType =objInfo.split("^")[9].split(",")[0];
	        $("#"+InfType).iCheck('check');
	         
	        var InsulatType =objInfo.split("^")[12].split(",")[0];
	        $("#"+InsulatType).iCheck('check');
	       
			var ContactList =objInfo.split("^")[13]; 
	        for (var indx=0;indx<ContactList.split(",").length-1;indx++) { 
	        	var Contact = ContactList.split(",")[indx];
	        	$("#"+Contact).iCheck('check');
	        }
			 
			var DropletList =objInfo.split("^")[14]; 
	        for (var indx=0;indx<DropletList.split(",").length-1;indx++) { 
	        	var Droplet = DropletList.split(",")[indx];
	            $("#"+Droplet).iCheck('check');
	        }

			var PlaceList =objInfo.split("^")[15]; 
	        for (var indx=0;indx<PlaceList.split(",").length-1;indx++) { 
	        	var Place = PlaceList.split(",")[indx];
	            $("#"+Place).iCheck('check');
	        }

			var UnitList =objInfo.split("^")[16]; 
	        for (var indx=0;indx<UnitList.split(",").length-1;indx++) { 
	        	var Unit = UnitList.split(",")[indx];
	            $("#"+Unit).iCheck('check');
	        } 
	        $.form.SetValue("txtUnitExt",objInfo.split("^")[17]);
	        
	        var TreatMent =objInfo.split("^")[18].split(",")[0];
	        $("#"+TreatMent).iCheck('check');
	        
	        var EnvMent =objInfo.split("^")[19].split(",")[0];
	        $("#"+EnvMent).iCheck('check');
	         
	        var ClothMent =objInfo.split("^")[20].split(",")[0];
	        $("#"+ClothMent).iCheck('check');
            
            var VisitList =objInfo.split("^")[21]; 
	        for (var indx=0;indx<VisitList.split(",").length-1;indx++) { 
	        	var Visit = VisitList.split(",")[indx];
	            $("#"+Visit).iCheck('check');
	        }

            var EndList =objInfo.split("^")[22]; 
	        for (var indx=0;indx<EndList.split(",").length-1;indx++) { 
	        	var End = EndList.split(",")[indx];
	            $("#"+End).iCheck('check');
	        }
	        $.form.SetValue("txtResume",objInfo.split("^")[23]);
        }else{
	        $.form.SetValue("chkInfType",'');
	        $.form.SetValue("chkInsulatType",'');
	        $.form.SetValue("chkContactList",'');
	        $.form.SetValue("chkDropletList",'');
	        $.form.SetValue("chkPlaceList",'');
	        $.form.SetValue("chkUnitList",'');
	        $.form.SetValue("txtUnitExt",'');
	        $.form.SetValue("chkTreatMent",'');
	        $.form.SetValue("chkEnvMent",'');
	        $.form.SetValue("chkClothMent",'');
	        $.form.SetValue("chkVisitList",'');
	        $.form.SetValue("chkEndList",'');
	        $.form.SetValue("txtResume",'');
        }

	    layer.open({
			type: 1,
			zIndex: 100,
			area: ['80%','100%'],
			title: [imgHtml+' '+rd["PatName"]]+'  ��ҩ������', 
			content: $('#layer_two'),
			//maxmin: true,
       		btn: ['����','�ύ','���','����','�ر�'],
			btnAlign: 'c',
			yes: function(index, layero){// ����
				if (!verifyReport()){
					return;
				};
		 		var ret = obj.Layer_Save("1");
				if(parseInt(ret)>0)
				{
					obj.gridCtlResult.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridCtlResult,"INFMBRID",ret);
						if (rowIndex > -1){
							var rd =obj.gridCtlResult.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('����ɹ�!',{time: 2000,icon: 1});
					},false);
					return true;
				}
				else
				{
					if(parseInt(ret)=='-1') {
						layer.msg('�����;��������ݱ���ʧ��!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-2') {
						layer.msg('������Ϣ����ʧ��!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-3') {
						layer.msg('������־��Ϣ����ʧ��!',{icon: 2});
						return false;
					}
				}
			},
			btn2: function(index, layero){ // �ύ
				if (!verifyReport()){
					return;
				};
				var ret = obj.Layer_Save("2");
				if(parseInt(ret)>0)
				{
					obj.gridCtlResult.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridCtlResult,"INFMBRID",ret);
						if (rowIndex > -1){
							var rd =obj.gridCtlResult.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('�ύ�ɹ�!',{time: 2000,icon: 1});
					},false);
					return true;				
				}
				else
				{
					if(parseInt(ret)=='-1') {
						layer.msg('�����;����������ύʧ��!!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-2') {
						layer.msg('������Ϣ�ύʧ��!!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-3') {
						layer.msg('������־��Ϣ�ύʧ��!!',{icon: 2});
						return false;
					}
				}				  	
			},
			btn3: function(index, layero){ // ���
				var ret = obj.Layer_Save("3");
				if(parseInt(ret)>0)
				{
					obj.gridCtlResult.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridCtlResult,"INFMBRID",ret);
						if (rowIndex > -1){
							var rd =obj.gridCtlResult.row(rowIndex).data();
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
			btn4: function(index, layero){ // ����
				var ret = obj.Layer_Save("4");
			  	if(parseInt(ret)>0)
				{
					obj.gridCtlResult.ajax.reload(function(){
						layer.msg('���ϳɹ�!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('����ʧ��!',{icon: 2});
					return false;
				}	
			},
			success: function(layero){
				var button0 = layero.find(".layui-layer-btn0"); //����
				var button1 = layero.find(".layui-layer-btn1"); //�ύ
				var button2 = layero.find(".layui-layer-btn2"); //���
				var button3 = layero.find(".layui-layer-btn3"); //����
				if (!RepStatus) {
					$(button2).hide();
					$(button3).hide();
				}else if (RepStatus =='1') {
					$(button2).hide();
				}else if (RepStatus =='2') {
					$(button0).hide();
					if (CheckFlg !='1') {
						$(button2).hide();
					}
				}else if (RepStatus =='3') {
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					if (CheckFlg !='1') {
						$(button3).hide();
					}
				}else if (RepStatus =='4') {
					$(button2).hide();
					$(button3).hide();
				}
				
			}	
		}); 
    });
	
	function verifyReport(){
		//��Ⱦ����
		var InfType="";
        $('input:radio',$("#chkInfType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InfType=$(this).attr("id");
       		}
    	});
        //���뷽ʽ
        var InsulatType="";
        $('input:radio',$("#chkInsulatType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InsulatType=$(this).attr("id");
       		}
    	});
		var ErrorStr="";
        if (InfType=='') {
	        ErrorStr += '��Ⱦ���Ͳ�����Ϊ��!<br/>';
        }
        if (InsulatType=='') {
	        ErrorStr += '���뷽ʽ������Ϊ��!<br/>';
        }
        if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return  false;
		}
		return true;
	}
	obj.Layer_Save =function(Status) {
		var rd = obj.layer_rd;
        var ID           = rd["INFMBRID"];
		var AdmID        = rd["AdmID"];
		var LabRepDr     = rd["LabRepID"];
		var SubmissLocDr = rd["LocID"];
        var SpecimenDr   = rd["SpeID"];
        var SubmissDate  = rd["ActDate"];
        var BactDicDr    = rd["BacID"];
        var BactDesc     = rd["Bacteria"];
        var MRBDicDr     = rd["MRBID"];
        //ȡֵ
        //��Ⱦ����
        var InfType="";
        $('input:radio',$("#chkInfType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InfType=$(this).attr("id");
       		}
    	});
        //���뷽ʽ
        var InsulatType="";
        $('input:radio',$("#chkInsulatType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InsulatType=$(this).attr("id");
       		}
    	});
    	//�Ӵ�����
        var ContactList="";
        $('input:checkbox',$("#chkContactList")).each(function(){
       		if(true == $(this).is(':checked')){
            	ContactList+=$(this).attr("id")+",";
       		}
    	});
        //��ĭ����
        var DropletList="";
        $('input:checkbox',$("#chkDropletList")).each(function(){
       		if(true == $(this).is(':checked')){
            	DropletList+=$(this).attr("id")+",";
       		}
    	});
    	//��Ⱦ���˰���
        var PlaceList="";
        $('input:checkbox',$("#chkPlaceList")).each(function(){
       		if(true == $(this).is(':checked')){
            	PlaceList+=$(this).attr("id")+",";
       		}
    	});
        //���뵥Ԫ����
        var UnitList="";
        $('input:checkbox',$("#chkUnitList")).each(function(){
       		if(true == $(this).is(':checked')){
            	UnitList+=$(this).attr("id")+",";
       		}
    	});
    	//��Ⱦ��������
        var TreatMent="";
        $('input:radio',$("#chkTreatMent")).each(function(){
       		if(true == $(this).is(':checked')){
            	TreatMent=$(this).attr("id");
       		}
    	});
        //���������
        var EnvMent="";
        $('input:radio',$("#chkEnvMent")).each(function(){
       		if(true == $(this).is(':checked')){
            	EnvMent=$(this).attr("id");
       		}
    	});
        //�ú󱻷�����
        var ClothMent="";
        $('input:radio',$("#chkClothMent")).each(function(){
       		if(true == $(this).is(':checked')){
            	ClothMent=$(this).attr("id");
       		}
    	});
    	//̽���߹���
        var VisitList="";
        $('input:checkbox',$("#chkVisitList")).each(function(){
       		if(true == $(this).is(':checked')){
            	VisitList+=$(this).attr("id")+",";
       		}
    	});
        //��ĩ����
        var EndList="";
        $('input:checkbox',$("#chkEndList")).each(function(){
       		if(true == $(this).is(':checked')){
            	EndList+=$(this).attr("id")+",";
       		}
    	});
    	var UnitExt  = $.form.GetValue("txtUnitExt");
        var Resume   = $.form.GetValue("txtResume");
        
        //��ǿ������
        var HandHygiene="";
        //��������
        var SecondCase="";

		var InputMBRStr = ID;
		InputMBRStr += "^" + AdmID;
		InputMBRStr += "^" + LabRepDr;
		InputMBRStr += "^" + SpecimenDr;
		InputMBRStr += "^" + SubmissDate;
		InputMBRStr += "^" + SubmissLocDr;
		InputMBRStr += "^" + BactDicDr;
		InputMBRStr += "^" + BactDesc;
		InputMBRStr += "^" + MRBDicDr;
		InputMBRStr += "^" + InfType;
		InputMBRStr += "^" + HandHygiene;
		InputMBRStr += "^" + SecondCase;
		InputMBRStr += "^" + InsulatType;
		InputMBRStr += "^" + ContactList;
		InputMBRStr += "^" + DropletList;
		InputMBRStr += "^" + PlaceList;
		InputMBRStr += "^" + UnitList;
		InputMBRStr += "^" + UnitExt;
		InputMBRStr += "^" + TreatMent;
		InputMBRStr += "^" + EnvMent;
		InputMBRStr += "^" + ClothMent;
		InputMBRStr += "^" + VisitList;
		InputMBRStr += "^" + EndList;
		InputMBRStr += "^" + Resume;
	    InputMBRStr += "^" + "";
	    InputMBRStr += "^" + "";
	    InputMBRStr += "^" + $.LOGON.USERID;
	    //������Ϣ
	   	var InputRepStr = "";         // ����ID DHCHAI.IR.INFReport	
		InputRepStr += "^" + AdmID;
		InputRepStr += "^" + "5";
		InputRepStr += "^" + "";
		InputRepStr += "^" + "";
		InputRepStr += "^" + $.LOGON.LOCID;
		InputRepStr += "^" + $.LOGON.USERID; 
		InputRepStr += "^" + Status;
	
	    // ��־��Ϣ
	    var InputLogStr = "";            // DHCHAI.IR.INFReport
		InputLogStr += "^" + Status;     // ״̬
	    InputLogStr += "^" + "";         // �������
	    InputLogStr += "^" + $.LOGON.USERID;
	    var InputStr = InputMBRStr+"#"+InputRepStr+"#"+InputLogStr;
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.INFMBRSrv","SaveReport",InputStr);
		return retval;
	}
}
			
   
