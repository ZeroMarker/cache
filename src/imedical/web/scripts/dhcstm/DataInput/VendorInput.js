// 供应商数据导入
var VendorGrid = new Ext.grid.GridPanel({
		id: 'VendorGrid',
		tbar: [{
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = VendorGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "没有选中行");
						return;
					};
					if (selectedarr.length > 0) {
						VendorGrid.getStore().remove(selectedarr);
						VendorGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "检测数据",
				iconCls: 'page_gear',
				handler: function () {
					VendorGrid.CheckDataBeforeSave()
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					VendorGrid.clearData();
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {
					VendorGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
        fields: [
           	{name: 'Code'},
		    {name: 'Name'},
		    {name:'Tel'},
		    {name:'ConPerson'},
		    {name:'CtrlAcct'},

		    {name:'CrLimit'},  //采购限额
		    {name:'CategoryId'},
		    {name:'LstPoDate'},
		    {name:'Fax'},
		    {name:'President'},

			//{name:'PresidentId'},
			//{name:'Status'},
			//{name:'CrAvail'},

		    {name:'Address'},
			//{name:'RCFlag'},

		    {name:'ComLic'},  //工商执照
		    {name:'ComLicDate'},
		    {name:'RevReg'}, //税务登记
			{name:'RevRegDate'},
			{name:'MatManLic'}, //医疗器械经营许可证

			{name:'MatManLicDate'},
			{name:'MatEnrol'},   //医疗器械注册证
			{name:'MatEnrolDate'},
			{name:'Sanitation'},// 卫生许可证
			{name:'SanitationDate'},

			{name:'OrgCode'},  //组织机构代码
			{name:'OrgCodeDate'},
		    {name:'Gsp'},
		    {name:'GspDate'},
		    {name:'MatPro'},  //器械生产许可证

			{name:'MatProDate'},
			{name:'ProPermit'}, //生产制造认可表
			{name:'ProPermitDate'},
			{name:'ImportEnrol'}, //进口医疗器械注册证
		    {name:'ImportEnrolDate'},

		    {name:'ImportLic'}, //进口注册登记表
			{name:'ImportLicDate'},
		    {name:'AgentLic'},
		    {name:'AgentLicDate'},
			{name:'Promises'},




			{name:'TrustDeed'},
			{name:'Quality'},
			{name:'QualityDate'},
			{name:'SalesName'},
			{name:'SalesNameDate'},



			{name:'SalesTel'}
			]
		}),
        columns:[ new Ext.grid.RowNumberer(),
            {header:'代码',dataIndex:'Code'},
			{header:'名称',dataIndex:'Name'},
			{header:'电话',dataIndex:'Tel'},
			{header:'开户银行',dataIndex:'ConPerson'},
			{header:'开户账号',dataIndex:'CtrlAcct'},

			{header:'采购限额',dataIndex:'CrLimit'},
			{header:'供应商分类',dataIndex:'CategoryId'},
			{header:'合同截止日期', width: 100,dataIndex:'LstPoDate'},
			{header:'传真',dataIndex:'Fax'},
			{header:'法人代表',dataIndex:'President'},

			//{header:'法人代表Id',dataIndex:'PresidentId',hidden:true},
			//{header:'供应商状态',dataIndex:'Status',hidden:true},
			//{header:'注册资金',dataIndex:'CrAvail',hidden:true},
			{header:'地址',dataIndex:'Address'},
			//{header:'RCFlag',dataIndex:'RCFlag',hidden:true},

			{header:'工商执照',dataIndex:'ComLic'},
			{header:'工商执照-有效期', width: 100,dataIndex:'ComLicDate'},
			{header:'税务登记',dataIndex:'RevReg'},
			{header:'税务登记-效期', width: 100,dataIndex:'RevRegDate'},
			{header:'医疗器械经营许可证',dataIndex:'MatManLic'},

			{header:'医疗器械经营许可证-效期', width: 100,dataIndex:'MatManLicDate'},
			{header:'医疗器械注册证',dataIndex:'MatEnrol'},
			{header:'医疗器械注册证-效期', width: 100,dataIndex:'MatEnrolDate'},
			{header:'卫生许可证',dataIndex:'Sanitation'},
			{header:'卫生许可证-效期', width: 100,dataIndex:'SanitationDate'},

			{header:'组织机构代码',dataIndex:'OrgCode'},
			{header:'组织机构代码-效期', width: 100,dataIndex:'OrgCodeDate'},
			{header:'Gsp',dataIndex:'Gsp'},
			{header:'Gsp效期', width: 100,dataIndex:'GspDate'},
			{header:'器械生产许可证',dataIndex:'MatPro'},

			{header:'器械生产许可证-效期', width: 100,dataIndex:'MatProDate'},
			{header:'生产制造认可表',dataIndex:'ProPermit'},
			{header:'生产制造认可表-效期', width: 100,dataIndex:'ProPermitDate'},
			{header:'进口医疗器械注册证',dataIndex:'ImportEnrol'},
			{header:'进口医疗器械注册证-效期', width: 100,dataIndex:'ImportEnrolDate'},

			{header:'进口注册登记表',dataIndex:'ImportLic'},
			{header:'进口注册登记表-效期', width: 100,dataIndex:'ImportLicDate'},
			{header:'代理销售授权书',dataIndex:'AgentLic'},
			{header:'代理销售授权书-效期', width: 100,dataIndex:'AgentLicDate'},
			{header:'售后服务承诺书',dataIndex:'Promises'},

			{header:'法人委托书',dataIndex:'TrustDeed'},
			{header:'质量承诺书',dataIndex:'Quality'},
			{header:'质量承诺书-有效期', width: 100,dataIndex:'QualityDate'},
			{header:'业务员姓名',dataIndex:'SalesName'},
			{header:'业务员授权书-有效期', width: 100,dataIndex:'SalesNameDate'},

			{header:'业务员电话',dataIndex:'SalesTel'}
		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '供应商数据导入',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		save: function () {
			var grid = this;
			var listData = "";
			var rowCount = grid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);
				var data = "";
				var Code = rowData.get("Code");
				var Name = rowData.get("Name");
				var Tel = rowData.get("Tel");
				var ConPerson = rowData.get("ConPerson");
				var CtrlAcct = rowData.get("CtrlAcct");
				data = Code + "^" + Name + "^" + Tel + "^" + ConPerson + "^" + CtrlAcct
					var CrLimit = rowData.get("CrLimit");
				var CategoryId = rowData.get("CategoryId");
				var LstPoDate = rowData.get("LstPoDate");
				var Fax = rowData.get("Fax");
				var President = rowData.get("President");
				data = data + "^" + CrLimit + "^" + CategoryId + "^" + LstPoDate + "^" + Fax + "^" + President
					var Address = rowData.get("Address");
				var ComLic = rowData.get("ComLic");
				var ComLicDate = rowData.get("ComLicDate");
				var RevReg = rowData.get("RevReg");
				var RevRegDate = rowData.get("RevRegDate");
				var MatManLic = rowData.get("MatManLic");
				data = data + "^" + Address + "^" + ComLic + "^" + ComLicDate + "^" + RevReg + "^" + RevRegDate + "^" + MatManLic
					var MatManLicDate = rowData.get("MatManLicDate");
				var MatEnrol = rowData.get("MatEnrol");
				var MatEnrolDate = rowData.get("MatEnrolDate");
				var Sanitation = rowData.get("Sanitation");
				var SanitationDate = rowData.get("SanitationDate");
				data = data + "^" + MatManLicDate + "^" + MatEnrol + "^" + MatEnrolDate + "^" + Sanitation + "^" + SanitationDate
					var OrgCode = rowData.get("OrgCode");
				var OrgCodeDate = rowData.get("OrgCodeDate");
				var Gsp = rowData.get("Gsp");
				var GspDate = rowData.get("GspDate");
				var MatPro = rowData.get("MatPro");
				data = data + "^" + OrgCode + "^" + OrgCodeDate + "^" + Gsp + "^" + GspDate + "^" + MatPro
					var MatProDate = rowData.get("MatProDate");
				var ProPermit = rowData.get("ProPermit");
				var ProPermitDate = rowData.get("ProPermitDate");
				var ImportEnrol = rowData.get("ImportEnrol");
				var ImportEnrolDate = rowData.get("ImportEnrolDate");
				data = data + "^" + MatProDate + "^" + ProPermit + "^" + ProPermitDate + "^" + ImportEnrol + "^" + ImportEnrolDate
					var ImportLic = rowData.get("ImportLic");
				var ImportLicDate = rowData.get("ImportLicDate");
				var AgentLic = rowData.get("AgentLic");
				var AgentLicDate = rowData.get("AgentLicDate");
				var Promises = rowData.get("Promises");
				data = data + "^" + ImportLic + "^" + ImportLicDate + "^" + AgentLic + "^" + AgentLicDate + "^" + Promises
					var TrustDeed = rowData.get("TrustDeed");
				var Quality = rowData.get("Quality");
				var QualityDate = rowData.get("QualityDate");
				var SalesName = rowData.get("SalesName");
				var SalesNameDate = rowData.get("SalesNameDate");
				data = data + "^" + TrustDeed + "^" + Quality + "^" + QualityDate + "^" + SalesName + "^" + SalesNameDate

					var SalesTel = rowData.get("SalesTel");
				data = data + "^" + SalesTel
					if (listData == "") {
						listData = data;
					} else {
						listData = listData + xRowDelim() + data;
					}

			}

			if (listData == "") {
				Msg.info("warning", "没有需要上传的数据");
				return;
			}

			var mask = ShowLoadMask(Ext.getBody(), "上传中请稍候...");
			var url = URL + "?actiontype=SaveVendor";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					listData: listData
				},
				waitMsg: '保存中...',
				success: function (result, request) {

					mask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);

					if (jsonData.success == 'true') {
						var ret = jsonData.info;

						var arr = ret.split("^");
						var commitno = parseInt(arr[0]);
						var successno = parseInt(arr[1]);

						var defaultno = commitno - successno;
						if (commitno == successno) {
							Msg.info("success", "保存成功!");
						} else {
							Msg.info("warning", "共" + commitno + "条数据  " + "导入成功" + successno + "数据  " + "导入失败" + defaultno + "数据");
						}

					}

				},
				failure: function (resp, opts) {
					alert("服务器出现异常!!");
				}
			});
		}, //save end
		CheckDataBeforeSave: function () {

			var grid = this
				var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "没有需要导入数据!");
				return;
			}
			var ret = 0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);

				var Name = rowData.get("Name");
				if (Ext.isEmpty(Name)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
				var codetmp = rowData.get("Code")
					for (var j = 0; j < i; j++) {
						var tmpdata = grid.getStore().getAt(j);
						var repeatcode = tmpdata.get("Code");
						if (repeatcode == codetmp) {
							this.ChangeBgColor(i, "yellow");
							this.ChangeBgColor(j, "yellow");
							ret = ret + 1;
						}
					}
					var findindex = grid.getStore().findExact('Code', codetmp)
					if ((findindex != -1) && (findindex != i)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1;
					}
			}

			return ret;

		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
