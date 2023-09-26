// 厂商数据导入
var ManfGrid = new Ext.grid.GridPanel({
		id: 'ManfGrid',
		tbar: [{
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = ManfGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "没有选中行");
						return;
					};
					if (selectedarr.length > 0) {
						ManfGrid.getStore().remove(selectedarr);
						ManfGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "检测数据",
				iconCls: 'page_gear',
				handler: function () {
					ManfGrid.CheckDataBeforeSave();
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					ManfGrid.clearData();
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {
					if (ManfGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "存在检测不通过的数据行");
						return
					}
					ManfGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
        fields: [
           {name:'Code'},
           {name:'Name'},
           {name:'Address'},
           {name:'Tel'},
           {name:'ParManfId'},

           {name:'DrugPermit'},
           {name:'DrugPermitExp'},
           {name:'MatPermit'},
           {name:'MatPermitExp'},
           {name:'ComLic'},

           {name:'ComLicExp'},
           {name:'BusinessRegNo'},
           {name:'BusinessRegExpDate'},
           {name:'OrgCode'},
           {name:'OrgCodeExpDate'},

           {name:'TaxRegNo'},
           {name:'MatManLic'},
           {name:'MatManLicDate'}
			]
		}),
        columns:[ new Ext.grid.RowNumberer(),
            {header:'代码',dataIndex: 'Code'},
		    {header:'名称',dataIndex: 'Name'},
		    {header:'地址',dataIndex:'Address'},
		    {header:'电话',dataIndex:'Tel'},
		    {header:'上级厂商',dataIndex:'ParManfId'},

		    {header:'药物生产许可证',dataIndex:'DrugPermit'},
		    {header:'药物生产许可证效期',dataIndex:'DrugPermitExp'},
		    {header:'材料生产许可证',dataIndex:'MatPermit'},
		    {header:'材料生产许可证效期',dataIndex:'MatPermitExp'},
		    {header:'工商执照许可',dataIndex:'ComLic'},

		    {header:'工商执照许可效期',dataIndex:'ComLicExp'},
		    {header:'工商注册号',dataIndex:'BusinessRegNo'},
		    {header:'工商注册号效期',dataIndex:'BusinessRegExpDate'},
		    {header:'组织机构代码',dataIndex:'OrgCode'},
		    {header:'组织机构代码效期',dataIndex:'OrgCodeExpDate'},

		    {header:'税务登记号',dataIndex:'TaxRegNo'},
		    {header:'器械经营许可证',dataIndex:'MatManLic'},
		    {header:'器械经营许可证效期',dataIndex:'MatManLicDate'}
		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '厂商数据导入',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		save: function () {
			var listData = "";
			var grid = this
				var rowCount = grid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);
				var Code = rowData.get("Code");
				var Name = rowData.get("Name");
				var Address = rowData.get("Address");
				var Tel = rowData.get("Tel");
				var ParManfId = rowData.get("ParManfId");
				var DrugPermit = rowData.get("DrugPermit");
				var DrugPermitExp = rowData.get("DrugPermitExp");
				var MatPermit = rowData.get("MatPermit");
				var MatPermitExp = rowData.get("MatPermitExp");
				var ComLic = rowData.get("ComLic");
				var ComLicExp = rowData.get("ComLicExp");
				var BusinessRegNo = rowData.get("BusinessRegNo");
				var BusinessRegExpDate = rowData.get("BusinessRegExpDate");
				var OrgCode = rowData.get("OrgCode");
				var OrgCodeExpDate = rowData.get("OrgCodeExpDate");
				var TaxRegNo = rowData.get("TaxRegNo");
				var MatManLic = rowData.get("MatManLic");
				var MatManLicDate = rowData.get("MatManLicDate");
				var data = Code + "^" + Name + "^" + Address + "^" + Tel + "^" + ParManfId + "^"
					+DrugPermit + "^" + DrugPermitExp + "^" + MatPermit + "^" + MatPermitExp + "^" + ComLic + "^" +
					ComLicExp + "^" + BusinessRegNo + "^" + BusinessRegExpDate + "^" + OrgCode + "^" + OrgCodeExpDate + "^"
					 + TaxRegNo + "^" + MatManLic + "^" + MatManLicDate;
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
			var url = URL + "?actiontype=SaveManf";
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
				scope: this
			});
		},
		CheckDataBeforeSave: function () {
			var grid = this
				var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "没有需要导入数据记录!");
				return;
			}
			for (var i = 0; i < rowCount; i++) {
				var ret = 0;
				var rowData = grid.getStore().getAt(i);
				var Code = rowData.get("Code");
				var Name = rowData.get("Name");
				if (Ext.isEmpty(Name)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var Address = rowData.get("Address");
				var Tel = rowData.get("Tel");
				var ParManfId = rowData.get("ParManfId");
				var DrugPermit = rowData.get("DrugPermit");
				var DrugPermitExp = rowData.get("DrugPermitExp");
				var MatPermit = rowData.get("MatPermit");
				var MatPermitExp = rowData.get("MatPermitExp");
				var ComLic = rowData.get("ComLic");
				var ComLicExp = rowData.get("ComLicExp");
				var BusinessRegNo = rowData.get("BusinessRegNo");
				var BusinessRegExpDate = rowData.get("BusinessRegExpDate");
				var OrgCode = rowData.get("OrgCode");
				var OrgCodeExpDate = rowData.get("OrgCodeExpDate");
				var TaxRegNo = rowData.get("TaxRegNo");
				var MatManLic = rowData.get("MatManLic");
				var MatManLicDate = rowData.get("MatManLicDate");
			}
			return ret;
		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
