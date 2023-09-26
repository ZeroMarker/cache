var init = function() {
	var HospId=gHospId;
	var TableName="APC_Vendor";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Query();
			};
		}
	}
	
	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(VendorMainGrid);
		$UI.clear(VendorDetailGrid);
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('#MainConditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		VendorMainGrid.load({
			ClassName: 'web.DHCSTMHUI.SynPicShow',
			QueryName: 'QueryNotAuditVendor',
			Params:Params
		});
	}
	
	var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM')
	var tmpl = "<li class='imgbox'><img id=${RowId} data-original=http://"+FtpParamObj.FtpHttpSrc+"${PicSrc} src=http://"+FtpParamObj.FtpHttpSrc+"${PicSrc} alt=${ImgType}></li>" +
				"<div style='text-align:center'>${ImgType}</div>";
	function showPics(data){
		$.tmpl(tmpl,data).appendTo( "#PicsList" );
		$("#PicsList").each(function(){
			var i=$(this);
			var p=i.find("li");
			p.click(function(){
				if(!!$(this).hasClass("selectedpic")){
					$(this).removeClass("selectedpic");
				}else{
					$(this).addClass("selectedpic").siblings("li").removeClass("selectedpic");
				}
			})
		})
		$('#PicsList').viewer({zIndex:9999999999999});
	}
	
	function Audit(){
		var Row=VendorDetailGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要审核的供应商资质!");
			return;
		}
		var Params=JSON.stringify(addSessionParams({RowId:Row.RowId}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.SynPicShow',
			MethodName: 'jsAudit',
			Params:Params
		},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					$UI.clear(VendorDetailGrid);
					VendorDetailGrid.commonReload();
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
	}
	function Refuse(){
		var Row=VendorDetailGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要拒绝的供应商资质!");
			return;
		}
		var Params=JSON.stringify(addSessionParams({RowId:Row.RowId}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.SynPicShow',
			MethodName: 'jsRefuse',
			Params:Params
		},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					$UI.clear(VendorDetailGrid);
					VendorDetailGrid.commonReload();
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
	}
	
	/*--Grid--*/
	var VendorDetailCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		},{
			title:"类型",
			field:'Type',
			width:100,
			hidden:true
		},{
			title:"类型",
			field:'TypeDesc',
			width:150
		},{
			title:"证件号",
			field:'RegNo',
			width:300
		},{
			title:"日期",
			field:'RegDate',
			width:130
		}
	]];
	
	var VendorDetailGrid = $UI.datagrid('#VendorDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SynPicShow',
			QueryName: 'QueryNotAuditVendorDetail'
		},
		columns: VendorDetailCm,
		toolbar:[{
			text: '审核',
			iconCls: 'icon-accept',
			handler: function () {
				Audit();
			}
		},{
			text: '拒绝',
			iconCls: 'icon-no',
			handler: function () {
				Refuse();
			}
		}],
		onSelect:function(index, row){
			$('#PicsList').empty();
			$('#PicsList').viewer('destroy');
			$.cm({
				ClassName: 'web.DHCSTMHUI.SynPicShow',
				MethodName: 'QueryNotVendorPic',
				VenIncId:row.RowId
			},function(jsonData){
				showPics(jsonData);
			});
		},
	})
	
	var VendorMainCm = [[{
			title:"VendorId",
			field:'VendorId',
			hidden:true,
			width:200
		},{
			title:"供应商代码",
			field:'VendorCode',
			width:200
		},{
			title:"供应商名称",
			field:'VendorDesc',
			width:250
		}
	]];
	
	var VendorMainGrid = $UI.datagrid('#VendorMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SynPicShow',
			QueryName: 'QueryNotAuditVendor'
		},
		onClickCell: function(index, filed ,value){	
			VendorMainGrid.commonClickCell(index,filed,value)
		},
		columns: VendorMainCm,
		onSelect:function(index, row){
			VendorDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.SynPicShow',
				QueryName: 'QueryNotAuditVendorDetail',
				VendorId: row.VendorId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				VendorMainGrid.selectRow(0);
			}
		}
	})
	InitHosp();
}
$(init);