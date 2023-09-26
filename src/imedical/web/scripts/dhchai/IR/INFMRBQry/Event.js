function InitMBRRepWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}

	/*****搜索功能*****/
	$("#btnsearch").on('click', function(){
	   $('#gridMBRRep').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridMBRRep.search(this.value).draw();
	    }
	});
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		obj.gridMBRRep.clear().draw();
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridMBRRep.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		});
	});
     //导出
    $("#btnExport").on('click', function(){
		obj.gridMBRRep.buttons(0,null)[1].node.click();
	});
    /*
 	//打印
    $("#btnPrint").on('click', function(){
	    obj.gridMBRRep.buttons(0,null)[2].node.click();
		
	});
	*/
	new $.fn.dataTable.Buttons(obj.gridMBRRep, {
		buttons: [
			{
				extend: 'csv',
				text:'导出'
			},
			{
				extend: 'excel',
				text:'导出',
				title:"耐药菌报告"
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
    $('#gridMBRRep').on('click','a.btnLabSen', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridMBRRep.row(tr);
		var rowData = row.data();
	    obj.ResultID=rowData["ResultID"];
	    var PatName=rowData["PatName"];
	    var Sex=rowData["Sex"];
	    obj.gridIRDrugSen.ajax.reload();
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
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			title:[imgHtml+' '+PatName]+'  药敏结果',
			content: $('#layer_one')		
		});	
    });
    
    //耐药菌报告
    $('#gridMBRRep').on('click','a.btnReprot', function (e) {
	    $.form.CheckBoxRender();
	    $.form.iCheckRender();
	  
		var tr = $(this).closest('tr');
		var row = obj.gridMBRRep.row(tr);
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
        var RepStatus = rd["StatusCode"];    
        var ReportID=rd["ID"];
        var objInfo = $.Tool.RunServerMethod("DHCHAI.IRS.INFMBRSrv","GetReportString",ReportID);
  
        if(ReportID) {
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
		 		var ret = obj.Layer_Save("1");
				if(parseInt(ret)>0)
				{
					obj.gridMBRRep.ajax.reload(function(){
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
				var ret = obj.Layer_Save("2");
				if(parseInt(ret)>0)
				{
					obj.gridMBRRep.ajax.reload(function(){
						layer.msg('提交成功!',{time: 2000,icon: 1});
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
			btn3: function(index, layero){ // 审核
				var ret = obj.Layer_Save("3");
				if(parseInt(ret)>0)
				{
					obj.gridMBRRep.ajax.reload(function(){
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
					obj.gridMBRRep.ajax.reload(function(){
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
					$(button0).hide();
					$(button1).hide();
					$(button2).hide();
					$(button3).hide();
				}
				
			}	
		}); 
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
        var INFMBRID     = rd["ID"];
		var AdmID        = rd["AdmID"];
		var LabRepDr     = rd["LabRepID"];
		var SubmissLocDr = rd["LocID"];
        var SpecimenDr   = rd["SpeID"];
        var SubmissDate  = rd["SubmissDate"];
        var BactDicDr    = rd["BacID"];
        var BactDesc     = rd["BactDesc"];
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

		var InputMBRStr = INFMBRID;
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
	    var InputStr = InputMBRStr+"#"+InputRepStr+"#"+InputLogStr;
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
/*
//Chrome在窗口改变大小时会执行两次       
var isResizing = false;
window.onresize =function(){	
	if (!isResizing) {
		getContentSize();   
		setTimeout(function () {
			isResizing = false;
		}, 100);
	}
	isResizing = true;
}
window.onload = function(){
	 setTimeout(function () {
     	getContentSize();
    }, 100);
}
*/
