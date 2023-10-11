var selectedText = "";
var FOUCSPOSTION=0;
var insrtCurrentId = "";
//保存表单数据 add by yjn 20171228
function saveForm() {
  var formValues = Ext.getCmp('inputForm').getForm().getValues();
  var grid = window.parent.Ext.getCmp('mygrid');
  if (grid.getSelectionModel().selections.length == 0) {
    window.parent.additm();
  }
  var row = grid.getSelectionModel().lastActive;
  for (var i = 0; i < grid.colModel.getColumnCount(); i++) {
    var index = grid.colModel.getDataIndex(i);
    grid.store.getAt(row).set(index, formValues[index]);
  }
  grid.store.commitChanges();
  // window.parent.save();
  window.parent.SaveComm('N');
  window.parent.find();
  grid.getSelectionModel().selectRow(row);
}

function resetForm() {
  //Ext.getCmp('inputForm').getForm().reset();
  var formArr = initFormArr();
  for (var i = 0; i < formArr.length; i++) {
    if ((formArr[i] == "CareDate") || (formArr[i] == "CareTime") || (formArr[i] == "par") || (formArr[i] == "rw")) continue;
    Ext.getCmp(formArr[i]).setValue("");
  }
}

function initFormArr() {
    var formArr = [];
    var grid = window.parent.Ext.getCmp('mygrid')
    for (var i = 0; i < grid.colModel.getColumnCount(); i++) {
      var index = grid.colModel.getDataIndex(i);
      var filterString = "^User^RecUser^";
      if (filterString.indexOf("^" + index + "^") > -1) {
        continue;
      }
      formArr.push(index);
    }
    return formArr;
  }

  //光标上下移动 yjn
function moveFocus() {
  var formArr = arguments[0];
  var curItm = arguments[1];
  var direction = arguments[2];
  var nextIndex;
  for (var i = 0; i < formArr.length; i++) {
    if (formArr[i] == curItm) {
      if ((i == 0) && (direction === "UP")) {
        continue;
      }
      if ((i == formArr.length - 1) && (direction === "UP")) {
        continue;
      }
      switch (direction) {
        case "UP":
          nextIndex = i - 1;
          break;
        case "DOWN":
          nextIndex = i + 1;
          break;
        default:
          nextIndex = i;
          break;
      }
    }
  }
  Ext.getCmp(formArr[nextIndex]).focus();
}

Ext.onReady(function() {
  function createPanelFieldItem(columnConfig,num) {
	var headerDesc="";
	var headerDesc = tkMakeServerCall("web.DHCNurHCRecComm","getHeader", EmrCode,num);
	if(headerDesc==""){
		headerDesc=columnConfig.header
	}
    var itemConfig = {
      id: columnConfig.dataIndex,
      name: columnConfig.dataIndex,
      fieldLabel: headerDesc
    };
    var field = columnConfig.editor.field;
    if (field.format === "Y-m-d") {
      //日期控件
      itemConfig.xtype = "datefield";
      itemConfig.format = field.format;
      itemConfig.allowBlank = false;
    }
	 else if (field.format === "d/m/Y") {
      //日期控件
      itemConfig.xtype = "datefield";
      itemConfig.format = field.format;
      itemConfig.allowBlank = false;
    }else if (field.format === "H:i") {
      //时间控件
      itemConfig.xtype = "timefield";
      itemConfig.format = field.format;
      itemConfig.allowBlank = false;
    } else if (field.store) {
      //combox控件
      itemConfig.xtype = "combo";
      itemConfig.displayField = "id";
      itemConfig.valueField = "desc";
      itemConfig.store = field.store;
      itemConfig.mode = "local";

    } else if (columnConfig.dataIndex === "CaseMeasure") {
      itemConfig.xtype = "textarea";
      // itemConfig.autoHeight =true;
      itemConfig.height = 300;
	  itemConfig.width=600;
    }
    //隐藏id，方便保存用 add by yjn
    if ((itemConfig.id == "rw") || (itemConfig.id == "par")) {
      itemConfig.hidden = true;
      itemConfig.hideLabel = true;
    }

    return itemConfig;
  }
  var gridColumnModel = window.parent.Ext.getCmp('mygrid').colModel.config;
  console.log(gridColumnModel);
  //alert(gridColumnModel);
  var items = [];
  var num = 1;
  //var CaseMeasure_itm="";
  gridColumnModel.forEach(function(columnConfig, index) {
    //itemConfig=Object.assign(itemField,itemConfig);
    var filterString = "^User^RecUser^";
    if (filterString.indexOf("^" + columnConfig.dataIndex + "^") > -1) {
      return;
    }
    // if (columnConfig.dataIndex == "Item7") {
    //   var itemConfig = {
    //     xtype: 'panel',
    //     border: false,
    //     width: 500,
    //     layout: 'column',
    //     items: [{
    //       columnWidth: .17,
    //       xtype: "label",
    //       text: "种类:"
    //     }, {
    //       columnWidth: .36,
    //       xtype: "textfield",
    //       id: columnConfig.dataIndex,
    //       name: columnConfig.dataIndex,
    //       fieldLabel: columnConfig.header
    //     }, {
    //       columnWidth: .25,
    //       text: "引用医嘱",
    //       handler: LinkOrder,
    //       xtype: "button"
    //     }]
    //   };
    //   items.push(itemConfig);
    // } else {
    //   items.push(createPanelFieldItem(columnConfig));
    // }
    
	items.push(createPanelFieldItem(columnConfig,num));	
	num = num + 1;

    
  });
  var west_item=new Ext.form.FormPanel({
    id: "inputForm",
    renderTo: Ext.getBody(),
    title: "信息录入",
    height: 320,
	  width:700,
    //autoScroll: true,
    bodyStyle : 'overflow-x:hidden; overflow-y:scroll',
    labelWidth: 80,
    frame: true,
    defaults: {
      xtype: "textfield",
      width: 180
    },
    items: items,
    buttons: [{
      id:'butSave',
      text: "保存",
      handler: saveForm
    }]
  }); 
  var div=document.createElement("div");
  div.setAttribute("id","linkOrderDiv");
  document.body.appendChild(div);
  var button = new Ext.Button({
    applyTo:"linkOrderDiv",
    id: "linkOrderBtn",
    text: "引用医嘱",
    handler: window.parent.LinkROrder  //引用弹窗位置调整 yjn
  });
  
  setTimeout(function(){
    var button = Ext.getCmp("linkOrderBtn");
    if (button) {
		
      button.el.dom.style.position = "absolute";
	  if(typeof(Ext.getCmp("Item7"))!="undefined"){
      button.el.dom.style.left = "270px";
      button.el.dom.style.top = "0";
	
	  }
	  else{
		 
	  button.el.dom.style.left = "300px";
      button.el.dom.style.top = "0";
	  button.hide();
	  }
	 if((EmrCode=="DHCNURBG_NFYYKFKFSK")||(EmrCode=="DHCNURBG_XSEHLJLD0706")){button.hide();}
     if(EmrCode="DHCNURBG_CHHLJLD"){Ext.getCmp("Item6").el.parent().appendChild(button.el);}
	  else if(EmrCode="DHCNURBG_NKGCD"){Ext.getCmp("Item24").el.parent().appendChild(button.el);}
	  else if(EmrCode="DHCNURBG_CQDCJLD"){Ext.getCmp("Item17").el.parent().appendChild(button.el);}
      else {Ext.getCmp("Item7").el.parent().appendChild(button.el);}
    }
  },200);
  var button = new Ext.Button({
    applyTo:"linkOrderDiv",
    id: "AddBtn",
    text: "增加",
    handler:window.parent.AddModel //引用弹窗位置调整 yjn
  });

  setTimeout(function(){
    var button = Ext.getCmp("AddBtn");
    if (button) {
      button.el.dom.style.position = "absolute";
	   if(typeof(Ext.getCmp("Item7"))!="undefined"){
      button.el.dom.style.left = "350px";
      button.el.dom.style.top = "0";
	  if((EmrCode=="DHCNURBG_NFYYKFKFSK")||(EmrCode=="DHCNURBG_XSEHLJLD0706")){button.hide();}
	   }else{
	  button.el.dom.style.left = "180px";
      button.el.dom.style.top = "0";
	  button.hide();
	   }
	
    if(EmrCode="DHCNURBG_CHHLJLD"){Ext.getCmp("Item6").el.parent().appendChild(button.el);}
	 
	  else if(EmrCode="DHCNURBG_NKGCD"){Ext.getCmp("Item24").el.parent().appendChild(button.el);}
	  else if(EmrCode="DHCNURBG_CQDCJLD"){Ext.getCmp("Item17").el.parent().appendChild(button.el);}
      else {Ext.getCmp("Item7").el.parent().appendChild(button.el);}
    }
  },200);
  /*
  setTimeout(function(){
    var itm = Ext.getCmp("CaseMeasure");
    if (itm) {
      itm.el.dom.style.position = "absolute";
      itm.el.dom.style.left = "300px";
      itm.el.dom.style.top = "0";
      Ext.getCmp("Item1").el.parent().appendChild(itm.el);
    }
  },200);
  */
  window.setValue = function(selectModel) {
    var selectedData = selectModel.getSelected().data;
    Ext.getCmp("inputForm").items.items.forEach(function(fieldItem) {
      fieldItem.setValue(selectedData[fieldItem.id]);
    })
	Ext.getCmp("inputForm").items.each(function (item, index, length) {
			if (item.getEl() != null) {
				item.on('beforeedit', beforeEditPgLinkFn);
				if ((item.xtype == "textfield") || (item.xtype == "textarea")) {
					//item.on('blur', beforeEditPgLinkFn);
				}
			}
	});	
  }

  //引用弹窗位置调整 yjn
  var rightClickPgMenu = new Ext.menu.Menu({
    id: 'rightClickCont',
    items: [{
      text: '知识库',
      handler: window.parent.LinkKnow
    }, {
      text: '检验结果',
      handler: window.parent.LinkLis
    }, {
      text: '检查结果',
      handler: window.parent.LinkPacs
    }, {
      text: '引用医嘱',
      handler: window.parent.LinkNROrder
    }, {
      text: '引用诊断',
      handler: window.parent.LinkDiag
    }, {
      text: '特殊字符',
      handler: window.parent.SepcialChar
    }, {
      text: '复制',
      handler: copy
    }, {
      text: '粘贴',
      handler: paste
    }]
  });
  west_item.items.each(function (item, index, length) {
    if (item.getEl() != null) {
      if ((item.xtype == "textfield") || (item.xtype == "textarea")) {
        item.getEl().on('contextmenu', function (e, t) {
          e.preventDefault();
          //e.stopEvent();
          window.parent.insrtCurrentId=item.name;
		  insrtCurrentId=item.name;
          rightClickPgMenu.showAt(e.getXY());
		  item.on('blur', beforeEditPgLinkFn);
        });
      }
    }
  });
  
  //监听↑↓键 yjn
  var formArr = initFormArr();
  for (var i = 0; i < formArr.length; i++) {
    Ext.getCmp(formArr[i]).on('specialkey', function(field, e) {
      if (e.getKey() === Ext.EventObject.DOWN) {
        moveFocus(formArr, field.id, "DOWN");
      } else if (e.getKey() == Ext.EventObject.UP) {
        moveFocus(formArr, field.id, "UP");
      } else {}
    });
  }
  //监听 by lmm

	var txtAre=document.getElementById(window.parent.insrtCurrentId);	
	if (txtAre) {
        txtAre.addEventListener("mouseup", function (e) {
            if (typeof document.selection != "undefined") {
                selectedText = document.selection.createRange().text;
            } else {
                selectedText = txtAre.value.substr(txtAre.selectionStart, txtAre.selectionEnd - txtAre.selectionStart);
            }
        });
    }
  
  if(session['LOGON.GROUPDESC'].indexOf("护士")<0) {
    var butSave=Ext.getCmp("butSave");
    //butSave.hide();
  }
  var east_item=new Ext.form.FormPanel({
    id: "inputForm1",
    renderTo: Ext.getBody(),
    title: "",
    height: 520,
	width:400,
    autoScroll: true,
    labelWidth: 80,
    frame: true,
    defaults: {
      xtype: "textfield",
      width: 180
    }
  });
	new Ext.Viewport({
        layout: "border",
        items: [
            west_item, east_item]
    });

});
///by lmm 粘贴复制
function paste() {
	var clipboard = window.clipboardData.getData('Text');
	clipboard == null ? alert('no data') : InserTextComm(clipboard);
}
function beforeEditPgLinkFn(e) {
	FOUCSPOSTION = 0;
	insrtCurrentId = e.id;
	var el = document.getElementById(insrtCurrentId);
	var textarea = Ext.getCmp(insrtCurrentId);
	if (textarea.getValue() == "") { return; } //空值的按钮不用获取FOUCSPOSTION
	if (el.selectionStart) {
		FOUCSPOSTION = el.selectionStart;
		return el.selectionStart;
		alert(4444)
	} else if (document.selection) {
		try {
			el.focus();
		}
		catch (ex) {
			return;
		}
		var workRange = document.selection.createRange();
		el.select();
		var allRange = document.selection.createRange();
		alert(FOUCSPOSTION)
		if (allRange.text.length == 0) { return }      //因为上面程序el.focus(); 失焦的事件程序走到这里就不走了。
		workRange.setEndPoint("StartToStart", allRange);
		FOUCSPOSTION = workRange.text.length;
		workRange.collapse(false);
		workRange.select();
	}
	// var grid1 = Ext.getCmp('mygrid');
	// var textarea1 = grid1.getColumnModel().getCellEditor(ZSKCULUMN, ZSKROW);
	// var id = textarea1.id;
	// var textarea2 = document.getElementById(id);
	// var textarea = Ext.getCmp(textarea1.field.id);
	// textarea.on('blur', getRangeData);
}
function getRangeData() {
	FOUCSPOSTION = 0;
	var grid1 = Ext.getCmp('mygrid');
	var el;
	if (grid1 == null) {
		id = insrtCurrentId;
		var el = document.getElementById(id);
		var textarea = Ext.getCmp(id);
		if (textarea.getValue() == "") { return; } //空值的按钮不用获取FOUCSPOSTION
	} else {
		var textarea1 = grid1.getColumnModel().getCellEditor(ZSKCULUMN, ZSKROW);
		var id = textarea1.id;
		var textarea2 = document.getElementById(id);
		el = document.getElementById(textarea2.lastChild.id);
		var textarea = Ext.getCmp(textarea2.lastChild.id);
		if (textarea.getValue() == "") { return; } //空值的按钮不用获取FOUCSPOSTION
	}
	if (el.selectionStart) {
		FOUCSPOSTION = el.selectionStart;
		return el.selectionStart;
	} else if (document.selection) {
		try {
			el.focus();
		}
		catch (ex) {
			return;
		}
		var workRange = document.selection.createRange();
		el.select();
		var allRange = document.selection.createRange();
		if (allRange.text.length == 0) { return }      //因为上面程序el.focus(); 失焦的事件程序走到这里就不走了。
		workRange.setEndPoint("StartToStart", allRange);
		FOUCSPOSTION = workRange.text.length;
		workRange.collapse(false);
		workRange.select();
	}
}
function InserTextComm(zsktxt) {
	//alert(insrtCurrentId);
	if (insrtCurrentId != "") {
		var insertObj = Ext.getCmp(insrtCurrentId);
		//弹窗位置显示在外层 add by yjn
		if(window.frames[0]){
			insertObj = window.frames[0].Ext.getCmp(insrtCurrentId);
		}
		var itemValue = insertObj.getValue();
		var itemValueStrat = "";
		var itemValueEnd = "";
		if (itemValue != "") {			
			itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
			itemValueEnd = itemValue.substring(FOUCSPOSTION);
		}
		insertObj.setValue(itemValueStrat + zsktxt + itemValueEnd);
	}
	else {
		var grid1 = Ext.getCmp('mygrid');
		var objRow = grid1.getSelectionModel().getSelections();
		if (objRow.length == 0) { alert("请先选择一条护理记录!"); return; }
		var itemValue = grid1.getSelectionModel().getSelections()[0].get(DATAINDEX);
		if (itemValue != null) {
			var itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
			var itemValueEnd = itemValue.substring(FOUCSPOSTION);
			grid1.getSelectionModel().getSelections()[0].set(DATAINDEX, (itemValueStrat + zsktxt + itemValueEnd));
		}
		else {
			grid1.getSelectionModel().getSelections()[0].set(DATAINDEX, zsktxt);
		}
	}
	FOUCSPOSTION = FOUCSPOSTION + zsktxt.length; //光标位置增加插入的字符串的长度
}
function copy()
{
	var txtAre=document.getElementById(window.parent.insrtCurrentId);	
	if (txtAre) {
        txtAre.addEventListener("mouseup", function (e) {
            if (typeof document.selection != "undefined") {
                selectedText = document.selection.createRange().text;
            } else {
                selectedText = txtAre.value.substr(txtAre.selectionStart, txtAre.selectionEnd - txtAre.selectionStart);
            }
        });
    }
	window.clipboardData.setData("Text",selectedText);//设置数据
	//alert("复制成功");
}
//end
