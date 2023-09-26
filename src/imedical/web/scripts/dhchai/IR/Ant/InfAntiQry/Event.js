//页面Event
function InitInfAntiQryWinEvent(obj){
	$.form.iCheckRender();
	//初始化字典数据
	$("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //渲染下拉框
	$.form.SelectRender("cboRuleAnti");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//默认未处置
	$('#ulStatus').val("-1");
	
	$.form.DateTimeRender('startDT');
	$.form.DateTimeRender('endDT');
	//默认获取前一天日期
	var lastDay = $.form.DateArr($.form.GetCurrDate('-'),2)[0];
	$("#startDT").val(lastDay);
	$("#endDT").val(lastDay);
	
	//状态事件
	$('#ulStatus > li').click(function (e) {
		e.preventDefault();
		$('#ulStatus > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).attr('data-val');
		$('#ulStatus').val(val);
		if((val=='-1')||(val=='0'))
		{
			//待处置
			$('#InReason').hide();
			$('#OutReason').hide();
			var wh = $(window).height();
			$("#divPanel").height(wh-220);
		}else if (val=='1')
		{
			//已处置
			$('#InReason').show();
			$('#OutReason').show();
			var wh = $(window).height();
			$("#divPanel").height(wh-250);
			
			checkStatus();
		}else if (val=='2')
		{
			//需关注
			$('#InReason').hide();
			$('#OutReason').hide();
			var wh = $(window).height();
			$("#divPanel").height(wh-220);	
		}
	});
	
	$("#chkOutReason, #chkInReason").on('ifChanged',function(){
		checkStatus();
	});
	
	function checkStatus(){
		var OutRea = $.form.GetValue("chkOutReason");
		var InRea = $.form.GetValue("chkInReason");
		if ((OutRea==1)&&(InRea==1)){
			$('#ulStatus').val("0|1");
		} else if ((OutRea==1)&&(InRea!=1)) {
			$('#ulStatus').val("0"); //不合理
		} else if ((OutRea!=1)&&(InRea==1)) {
			$('#ulStatus').val("1"); //合理
		} else {
			layer.msg('请选择处置状态!',{icon: 2});
			return false;
		}
	}
	
	obj.SelectLocList = new Array();
	obj.LocListStr = "";
	refreshLocList(); //初始加载科室列表
	
	$("#btnsearch").on('click', function(){
	   obj.gridPat.search($('#search').val()).draw();
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridPat.search(this.value).draw();
        }
	});
	
	$('#cboRuleAnti').on('change',function(){
		if (this.value){
			obj.gridPat.search(this.options[this.options.selectedIndex].text).draw();
		}else{
			obj.gridPat.search("").draw();
		}
	});
	
	//导出
    $("#btnExport").on('click', function(){
		obj.gridPat.buttons(0,null)[0].node.click();
	});
	
	$("#btnQuery").on("click", function(){
		checkInputDate();
		if (obj.SelectLocList.length != 0){
			myLoading();
			if ($(".Loading_animate_content").length != 0) {
				myLoadingBug();
				$(".Loading_animate_content").css("display","block");
			}
			obj.LocListStr = "";
			for (var i=0; i<obj.SelectLocList.length; i++){
				obj.LocListStr += ("|" + obj.SelectLocList[i]);
			}
			obj.LocListStr = obj.LocListStr.substr(1);
			setTimeout(refreshPatList,0.2*1000);  //错开达到异步
		} else {
			layer.alert('请选择科室！');
		}
	});
	
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		refreshLocList();
	});
	function checkInputDate () {
		var  sDt=$("#startDT").val();
		var  eDt=$("#endDT").val();		
		if(sDt==""||eDt=="")
		{
			return;
		}
		var d1 = new Date(sDt.replace(/\-/g, "\/"));  
		var d2 = new Date(eDt.replace(/\-/g, "\/"));
		if(sDt!=""&&eDt!=""&&d1>d2)  
		{  
			layer.alert('开始日期不能大于结束日期！');
			return;
		}
	}
	refreshPatList(); //初始化加载病人列表（空）
	
	//集成视图
	openViewPat_click=function(EpisodeID, indexTab)
	{
		var paadm = EpisodeID;
		indexTab = (indexTab) ? indexTab : 0;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+ paadm +'&IndexTab='+ indexTab +'&PowerType='+ obj.IsExper +'&EndDate='+ $("#endDT").val() +'&1=1';
		try {
			parent.layer.open({
				  type: 2,
				  area: ['95%', '100%'],
				  title:false,
				  closeBtn:0,
				  fixed: false, //不固定
				  maxmin: false,
				  maxmin: false,
				  content: [url,'no']
			});
		} catch(e) {
			//挂载到老版菜单中时，由于父页面层未引用layer而导致打开失败，直接在当前层打开弹出框 mayanpeng
			layer.open({
				  type: 2,
				  area: ['95%', '100%'],
				  title:false,
				  closeBtn:0,
				  fixed: false, //不固定
				  maxmin: false,
				  maxmin: false,
				  content: [url,'no']
			});
		}
		refreshPatList();
	};
	
	//刷新科室列表
	function refreshLocList()
	{
		var hospIDs = $.form.GetValue("cboHospital");
		var retval =  $.Tool.RunServerMethod("DHCHAI.BTS.LocationSrv","GetLocJsonByHospIDs", hospIDs,"","I","E","1");
		//var defaultData = eval("(" + retval + ")");
		var defaultData = $.parseJSON(retval);
		
		var $checkableTree = $('#treeview-checkable').treeview({
			data: defaultData,
			showIcon: false,
			showCheckbox: true,
			onNodeChecked: function(event, node) {
				if (node.tags) obj.SelectLocList.push(node.tags);
				var selectNodes = getChildNodeIdArr(node);
				if (selectNodes) {
					$('#treeview-checkable').treeview('checkNode', [selectNodes, { silent: false }]);
				}
				setParentNodeCheck(node);
			},
			onNodeUnchecked: function (event, node) {
				var selectNodes = getChildNodeIdArr(node);
				if (selectNodes) {
					$('#treeview-checkable').treeview('uncheckNode', [selectNodes, { silent: false }]);
				}
				var parentNode = $('#treeview-checkable').treeview('getParent', node);
				if (parentNode.state){
					if (node.tags) obj.SelectLocList.removeByValue(node.tags);
					var selectNodes = getChildNodeIdArr(parentNode); //获取所有同级节点
					var isChecked = false, allBrotherNode = null;
					for (var i=0; i<selectNodes.length; i++){
						allBrotherNode = $('#treeview-checkable').treeview('getNode', selectNodes[i]);
						if (typeof allBrotherNode.state == 'undefined') continue;
						if (allBrotherNode.state.checked){
							isChecked = true;
							break;
						}
					}
					if (!isChecked){
						$('#treeview-checkable').treeview('uncheckNode', $('#treeview-checkable').treeview('getParent', node));
					}
				}
			}
		});
		$checkableTree.treeview('collapseAll'); //折叠所有节点
	}
	
	//刷新病人列表
	function refreshPatList()
	{
		var hospIDs = $.form.GetValue("cboHospital");
		var start = $.form.GetValue("startDT");
		var end = $.form.GetValue("endDT");
		//if(obj.gridPat==undefined)
		obj.gridPat = $("#gridPat").DataTable({
			dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
			select: 'single',
			paging:true,
			ordering: true,
			destroy:true,
			columnDefs: [
				{"className": "dt-left", "targets": [5,6]},
				{"className": "dt-center", "targets": "_all"}
			],
			ajax: {
				"url": "dhchai.query.datatables.csp",
				"data": function (d) {
					d.ClassName = "DHCHAI.IRS.ASPProgramSrv";
					d.QueryName = "QryAspAntList";
					d.Arg1=hospIDs;
					d.Arg2=start;
					d.Arg3=end;
					d.Arg4=obj.LocListStr;
					d.Arg5=obj.IsExper;
					d.Arg6=$('#ulStatus').val();
					d.ArgCnt = 6;
				},
				"complete": function(){
					myLoadHiden();
					if ($('#cboRuleAnti').val() != '') {
						obj.gridPat.search($.form.GetText('cboRuleAnti')).draw();
					} else if ($('#search').val() != '') {
						obj.gridPat.search($('#search').val()).draw();
					}
				}
			},
			columns: [
				{"data": "ID"},
				{"data": "PatName"},
				{"data": null,
					render: function ( data, type, row ) {
						return '<a href="#" onclick="openViewPat_click('+ data.EpisodeID +',\'ASPOrdItem\')">'+ data.MrNo +'</a>';
					}
				},
				{
					"data": "Sex",
					render: function ( data, type, row ) {
						switch(data){
							case "F":
								return "女";
								break;
							case "M":
								return "男";
								break;
							default:
								return "未知";
						}
					}
					
				},
				{"data": "Age"},
				{"data": "AdmWard"},
				{"data": null,
					render: function ( data, type, row ) {
						var genericArr = data.Generic.split(",");
						var genericHtml='',genericNum=0;
						for (var i=0;i<genericArr.length; i++){
							genericHtml += '<span class="label label-info">'+genericArr[i]+'</span>&nbsp;';
							genericNum += genericArr[i].length;
							if (typeof(genericArr[i+1]) != "undefined") {
								if (genericNum + genericArr[i+1].length > 10) { //大于10个字换行，防止撑大表格
									genericHtml += '<br />';
									genericNum = 0;
								}
							}
						}
						return genericHtml;
					}
				},
				{"data": "PharOpinion",
					render: function (data, type, row) {
						return data.replace(new RegExp("未处置","g"),"");
					}
				},
				{"data": "ExperOpinion",
					render: function (data, type, row) {
						return data.replace(new RegExp("未处置","g"),"");
					}
				},
				{"data": "AdmDate"},
				{"data": "DischDate"}
			],
			"fnDrawCallback": function (oSettings) {
				$("#gridPat_wrapper .dataTables_scrollBody").mCustomScrollbar({
					theme : "dark-thick",
					axis: "xy",
					callbacks:{
						whileScrolling:function(){
							$('#gridPat_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
						}
					}
				});			
				$("#gridPat_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridReport tr td:first"));
			}
		});
		new $.fn.dataTable.Buttons(obj.gridPat, {
			buttons: [
				{
					extend: 'excel',
					text:'导出',
					title:"ASP抗菌药物评估"
					,footer: true
					,exportOptions: {
						columns: ':visible'
						,width:50
						,orthogonal: 'export'
					},
					customize: function( xlsx ) {
						var sheet = xlsx.xl.worksheets['sheet.xml'];
						
					}
				}
				/*
				,{
					extend: 'print',
					text:'打印'
					,title:""
					,footer: true
				}*/
			]
		});
	}
	obj.gridPat.on('dblclick', 'tr', function(e) {
		var rd = obj.gridPat.row(this).data();
		openViewPat_click(rd["EpisodeID"], "ASPOrdItem");
	});
	
	//获取所有子节点
	function getChildNodeIdArr(node) {
		var ts = [];
		if (node.nodes) {
			for (x in node.nodes) {
				ts.push(node.nodes[x].nodeId);
				if (node.nodes[x].nodes) {
					var getNodeToChild = getChildNodeIdArr(node.nodes[x]);
					for (j in getNodeToChild) {
						ts.push(getNodeToChild[j]);
					}
				}
			}
		} else {
			ts.push(node.nodeId);
		}
		return ts;
	}
	
	function setParentNodeCheck(node) {
		var parentNode = $("#treeview-checkable").treeview("getNode", node.parentId);
		if (parentNode.nodes) {
			var checkedCount = 0;
			for (x in parentNode.nodes) {
				if (typeof parentNode.nodes[x].state == 'undefined') continue;
				if (parentNode.nodes[x].state.checked == true) {
					checkedCount ++;
				} else {
					break;
				}
			}
			if ((checkedCount != 0) && (checkedCount === parentNode.nodes.length)) {
				$("#treeview-checkable").treeview("checkNode", parentNode.nodeId);
				setParentNodeCheck(parentNode);
			}
		}
	}
	Array.prototype.removeByValue = function(val) {
		for(var i=0; i<this.length; i++) {
			if(this[i] == val) {
				this.splice(i, 1);
				break;
			}
		}
	}
	
	function myLoading() {
		if ($(".Loading_animate_content").length != 0) {
			if ($(".Loading_animate_bg").length == 0) {
				var html = '<div class="Loading_animate_bg"></div>'
					+ '<div class="Loading_animate">Loading...</div>'
					+ '<div class="Loading_animate_font">加载中...</div>';
				$(".Loading_animate_content").append(html);
			}
		}
	}
	function myLoadingBug() {		
		$('.Loading_animate_bg').css({ height: $(document).height() });
		$('.Loading_animate_font').css({ left: ($(document).width() - 36) / 2 });
		$('.Loading_animate').css({ left: ($(document).width()) / 2 });
	}
	function myLoadHiden()
	{
		if ($(".Loading_animate_content").length != 0) {
				$(".Loading_animate_content").css("display", "none");
				$(".Loading_animate_font").text("加载中...");
		}
	}
	
	//默认获取前一天日期
	function getLastday(){
		var date = new Date(new Date()-24*60*60*1000);
		var mon = date.getMonth()+1;
		var day = date.getDate();
		var year = date.getFullYear();
		var mydate = year + "-" + (mon < 10 ? "0" + mon : mon) + "-" + (day < 10 ? "0" + day : day);
		return mydate;
	}
}
