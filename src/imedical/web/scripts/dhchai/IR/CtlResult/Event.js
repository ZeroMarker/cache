function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
	
    layer.config({  
		extend: 'layerskin/style.css' 
	});
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	else
	{
		//无审核权限 临床
		$('#selectFlag').hide();
		//$("#cboLocation").val($.LOGON.XLocID);  //临床登录科室
		$("#cboLocation").val($.LOGON.LOCID);  //临床登录科室
		//触发查询
		$("#btnQuery").click();
	}
	
	/*****搜索功能*****/
	$("#btnsearch").on('click', function(){
	   $('#gridCtlResult').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridCtlResult.search(this.value).draw();
	    }
	});
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){	    
	    var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		obj.gridCtlResult.clear().draw();
		if(DateFrom == ""){
			layer.msg('请输入开始日期！',{time: 2000,icon: 2});
			return;
		}
		if(DateTo == ""){
			layer.msg('请输入结束日期！',{time: 2000,icon: 2});
			return;
		}
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridCtlResult.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		});
	});
	//疑似筛查
    //链接选中方式
    $('#gridCtlResult').on('click','a.screen_single', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
		var patName = rowData.PatName;
		var EpisodeID=rowData.AdmID;
		obj.btnCCSingle_Click(patName,EpisodeID);
    });	
    obj.btnCCSingle_Click = function(patName,EpisodeID)
	{		
		var url = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID;
		obj.idxLayerMsg = layer.open({
			type: 2,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
			maxmin: false,
			title: ["疑似病例筛查","text-align:left;background-color: #4C9CE4;color:#fff"], 
			area: ['90%','90%'],
			content: [url,'no']
		});
	};
    $('#gridCtlResult').on('click','a.abstract_msg', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
		var EpisodeID=rowData.AdmID;
		obj.btnAbstractMsg_Click(EpisodeID);
    });		
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	

	    var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
	};
     //导出
    $("#btnExport").on('click', function(){
		obj.gridCtlResult.buttons(0,null)[1].node.click();
	});
    /*
 	//打印
    $("#btnPrint").on('click', function(){
	    obj.gridCtlResult.buttons(0,null)[2].node.click();
		
	});
	*/
	new $.fn.dataTable.Buttons(obj.gridCtlResult, {
		buttons: [
			{
				extend: 'csv',
				text:'导出'
			},
			{
				extend: 'excel',
				text:'导出',
				title:"耐药菌监测"
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
				text:'打印'
				,title:""
				,footer: true
			}
		]
	});

    //药敏结果链接选中方式
    $('#gridCtlResult').on('click','a.btnLabSen', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
	    obj.ResultID=rowData["ResultID"];
	    var PatName=rowData["PatName"];
	    var Sex=rowData["Sex"];
	    switch (Sex){
			case '女':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
				break;
			case '男':
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
			title:[imgHtml+' '+PatName]+'  药敏结果',
			content: $('#layer_one')			
		});
	
    });
    
    //耐药菌报告
    $('#gridCtlResult').on('click','a.btnReprot', function (e) {
	    $.form.CheckBoxRender();
	    $.form.iCheckRender();
		$("#txtUnitExt").attr("disabled","disabled");
		$('#chkUnitList .iCheck-helper').click(function(){
        	if($(this).parent().parent().text().indexOf("其他")>=0){
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
			case '女':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
				break;
			case '男':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
			default:
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
		}
        var ResultID=rd["ID"];
        var Flg = $.Tool.RunServerMethod("DHCHAI.IR.INFMBR","CheckIsMap",ResultID);
        if(parseInt(Flg)== '-1') {
	        layer.msg('本条记录中标本未维护标准名称对照，请先维护标本标准名称!',{time: 3000,icon: 2});
            return false;
        }else if (parseInt(Flg)== '-2') {
	        layer.msg('本条记录中细菌未维护标准名称对照，请先维护细菌标准名称!',{time: 3000,icon: 2});
            return false;     
        }else if (parseInt(Flg)== '-3') {
	        layer.msg('本条记录中细菌不是多重耐药菌，请先维护多重耐药菌分类!',{time: 3000,icon: 2});
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
			skin: 'btn-all-blue',
			area: ['80%','100%'],
			title: [imgHtml+' '+rd["PatName"]]+'  耐药菌报告', 
			content: $('#layer_two'),
			//maxmin: true,
       		btn: ['保存','提交','审核','删除','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){// 保存
				if (!verifyReport()){
					return;
				};
				if($("#txtResume").val().length>100){
					layer.msg('其他情况字数超过100！',{time: 2000,icon: 2});
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
						layer.msg('保存成功!',{time: 2000,icon: 1});
					},false);
					return true;
				}
				else
				{
					if(parseInt(ret)=='-1') {
						layer.msg('多重耐菌报告内容保存失败!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-2') {
						layer.msg('报告信息保存失败!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-3') {
						layer.msg('报告日志信息保存失败!',{icon: 2});
						return false;
					}
				}
			},
			btn2: function(index, layero){ // 提交
				if (!verifyReport()){
					return false;
				};
				if($("#txtResume").val().length>100){
					layer.msg('其他情况字数超过100！',{time: 2000,icon: 2});
					return false;
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
						layer.msg('提交成功!',{time: 2000,icon: 1});
					},false);
					return true;				
				}
				else
				{
					if(parseInt(ret)=='-1') {
						layer.msg('多重耐菌报告内容提交失败!!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-2') {
						layer.msg('报告信息提交失败!!',{icon: 2});
						return false;
					}else if (parseInt(ret)=='-3') {
						layer.msg('报告日志信息提交失败!!',{icon: 2});
						return false;
					}
				}				  	
			},
			btn3: function(index, layero){ // 审核
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
						layer.msg('审核成功!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('审核失败!',{icon: 2});
					return false;
				}	
			},
			btn4: function(index, layero){ // 删除
				var ret = obj.Layer_Save("4");
			  	if(parseInt(ret)>0)
				{
					obj.gridCtlResult.ajax.reload(function(){
						layer.msg('删除成功!',{time: 2000,icon: 1});
					},false);
					return true;						
				}
				else
				{
					layer.msg('删除失败!',{icon: 2});
					return false;
				}	
			},
			success: function(layero){
				var dh=$('div.layui-layer-content').height();
		        $('#layer_two').css('height',dh);
				var button0 = layero.find(".layui-layer-btn0"); //保存
				var button1 = layero.find(".layui-layer-btn1"); //提交
				var button2 = layero.find(".layui-layer-btn2"); //审核
				var button3 = layero.find(".layui-layer-btn3"); //删除
				$("#SumAssess").show();                         //显示总结性评价
				if (!RepStatus) {
					$(button2).hide();
					$(button3).hide();
					$('#SumAssess').hide();
				} else if (RepStatus == '1') {
				    $('#SumAssess').hide();
					$(button2).hide();
				}else if (RepStatus =='2') {
					$(button0).hide();
					if (CheckFlg !='1') {
						$(button2).hide();
					}
				} else if (RepStatus == '3') {
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
	//发送消息链接选中方式
    $('#gridCtlResult').on('click','a.btnMRBMsg', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
	    var AdmID=rowData["AdmID"];
	    var ResultID=rowData["ID"];
	    var MsgType="MBRMsgCode";
	    var Msg = "多耐分类:"+rowData["MRBDesc"]+",检出病原体:"+rowData["Bacteria"]
		
		var InputStr = AdmID +"^"+ MsgType +"^"+ $.LOGON.USERID + "^" + Msg+"^"+ResultID
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CtlMRBSrv","SendHISMRBMsg",InputStr);
		if(parseInt(retval)== '-1') {
	        layer.msg('发送消息的患者不存在！',{time: 3000,icon: 2});
            return false;
        }else if (parseInt(retval)== '-2') {
	        layer.msg('HIS多耐消息代码:MBRMsgCode未配置!',{time: 3000,icon: 2});
            return false;     
        }else if (parseInt(retval)== '-3') {
	        layer.msg('发送消息用户不存在!',{time: 3000,icon: 2});
            return false;     
        }else if(parseInt(retval)<1) {
	        layer.msg('发送消息失败！',{time: 3000,icon: 2});
            return false;     
        }
		layer.msg('成功向临床医生发送消息！',{time: 2000,icon: 1});
    });
	
	function verifyReport(){
		//感染类型
		var InfType="";
        $('input:radio',$("#chkInfType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InfType=$(this).attr("id");
       		}
    	});
        //隔离方式
        var InsulatType="";
        $('input:radio',$("#chkInsulatType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InsulatType=$(this).attr("id");
       		}
    	});
		var ErrorStr="";
        if (InfType=='') {
	        ErrorStr += '感染类型不允许为空!<br/>';
        }
        if (InsulatType=='') {
	        ErrorStr += '隔离方式不允许为空!<br/>';
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
        //取值
        //感染类型
        var InfType="";
        $('input:radio',$("#chkInfType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InfType=$(this).attr("id");
       		}
    	});
        //隔离方式
        var InsulatType="";
        $('input:radio',$("#chkInsulatType")).each(function(){
       		if(true == $(this).is(':checked')){
            	InsulatType=$(this).attr("id");
       		}
    	});
    	//接触隔离
        var ContactList="";
        $('input:checkbox',$("#chkContactList")).each(function(){
       		if(true == $(this).is(':checked')){
            	ContactList+=$(this).attr("id")+",";
       		}
    	});
        //飞沫隔离
        var DropletList="";
        $('input:checkbox',$("#chkDropletList")).each(function(){
       		if(true == $(this).is(':checked')){
            	DropletList+=$(this).attr("id")+",";
       		}
    	});
    	//感染病人安置
        var PlaceList="";
        $('input:checkbox',$("#chkPlaceList")).each(function(){
       		if(true == $(this).is(':checked')){
            	PlaceList+=$(this).attr("id")+",";
       		}
    	});
        //隔离单元设置
        var UnitList="";
        $('input:checkbox',$("#chkUnitList")).each(function(){
       		if(true == $(this).is(':checked')){
            	UnitList+=$(this).attr("id")+",";
       		}
    	});
    	//感染病人诊疗
        var TreatMent="";
        $('input:radio',$("#chkTreatMent")).each(function(){
       		if(true == $(this).is(':checked')){
            	TreatMent=$(this).attr("id");
       		}
    	});
        //环境物表处理
        var EnvMent="";
        $('input:radio',$("#chkEnvMent")).each(function(){
       		if(true == $(this).is(':checked')){
            	EnvMent=$(this).attr("id");
       		}
    	});
        //用后被服处理
        var ClothMent="";
        $('input:radio',$("#chkClothMent")).each(function(){
       		if(true == $(this).is(':checked')){
            	ClothMent=$(this).attr("id");
       		}
    	});
    	//探视者管理
        var VisitList="";
        $('input:checkbox',$("#chkVisitList")).each(function(){
       		if(true == $(this).is(':checked')){
            	VisitList+=$(this).attr("id")+",";
       		}
    	});
        //终末消毒
        var EndList="";
        $('input:checkbox',$("#chkEndList")).each(function(){
       		if(true == $(this).is(':checked')){
            	EndList+=$(this).attr("id")+",";
       		}
    	});
    	var UnitExt  = $.form.GetValue("txtUnitExt");
        var Resume   = $.form.GetValue("txtResume");
        
        //加强手卫生
        var HandHygiene="";
        //续发病例
        var SecondCase="";
        //审核报告总结性评价
	var RepAssess ="";
        var AssessVal = $('#SumAssess input[name="Assess"]:checked ').val();
        if(AssessVal){
		RepAssess =AssessVal;
	}
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
	    //报告信息
	   	var InputRepStr = "";         // 报告ID DHCHAI.IR.INFReport	
		InputRepStr += "^" + AdmID;
		InputRepStr += "^" + "5";
		InputRepStr += "^" + "";
		InputRepStr += "^" + "";
		InputRepStr += "^" + $.LOGON.LOCID;
		InputRepStr += "^" + $.LOGON.USERID; 
		InputRepStr += "^" + Status;
	
	    // 日志信息
	    var InputLogStr = "";            // DHCHAI.IR.INFReport
		InputLogStr += "^" + Status;     // 状态
	    InputLogStr += "^" + "";         // 操作意见
	    InputLogStr += "^" + $.LOGON.USERID;
	    var InputStr = InputMBRStr + "#" + InputRepStr + "#" + InputLogStr;
	    var InputStr = InputStr + "#" + RepAssess;      //新增报告总结性评价
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.INFMBRSrv","SaveReport",InputStr);
		return retval;
	}
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


