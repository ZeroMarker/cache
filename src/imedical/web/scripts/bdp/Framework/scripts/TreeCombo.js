/********************** treecombo控件 ****************************/
Ext.namespace("Ext.tet");
Ext.tet.TreeComboField = Ext.extend(Ext.form.TwinTriggerField, {
    valueField : "Id",
    labelSeparator:"",
    displayField : "Name",
    haveShow : false,
	editable : true,
	enableKeyEvents: true,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-twin-triggers',
    onTrigger1Click : function(){
    	this.clearValue();
    },
    onTrigger2Click : function() {
        if (!this.tree.rendered) {
            this.treeId = Ext.id();
            var panel = document.createElement('div');
            panel.style.backgroundColor='#ffffff';
            panel.id = this.treeId;
            this.getEl().dom.parentNode.appendChild(panel);
            this.tree.render(this.treeId);
            this.tree.setWidth(this.width);
            this.tree.getEl().alignTo(this.getEl(), "tl-bl");
        }else{
	        if(this.tree.isVisible()){
	        	this.tree.hide();
	        }else{
	        	this.tree.root.reload();
	        	this.tree.show();
	        }
        }
    },
    initComponent : function() {
        Ext.tet.TreeComboField.superclass.initComponent.call(this);
    },
    onRender : function(ct, position) {
        Ext.tet.TreeComboField.superclass.onRender.call(this, ct, position);
        this.tree.on("click", this.choice, this);
        this.tree.on("dblclick",function(){this.tree.hide();},this);
        if (this.hiddenName) {
            this.hiddenField = this.el.insertSibling({
                tag : 'input',
                type : 'hidden',
                name : this.hiddenName,
                id : (this.hiddenId || this.hiddenName)
            }, 'before', true);
            this.hiddenField.value = this.hiddenValue !== undefined ? this.hiddenValue : this.value !== undefined ? this.value : '';
            this.el.dom.removeAttribute('name');
        }
        if (!this.editable) {
            this.editable = true;
            this.setEditable(false);
        }
    },
    onKeyUp : function() {
    	if (!this.tree.rendered) {
            this.treeId = Ext.id();
            var panel = document.createElement('div');
            panel.style.backgroundColor='#ffffff';
            panel.id = this.treeId;
            this.getEl().dom.parentNode.appendChild(panel);
            this.tree.render(this.treeId);
            this.tree.setWidth(this.width);
            this.tree.getEl().alignTo(this.getEl(), "tl-bl");
        }else{
	        if(this.tree.isVisible()){
	        	this.tree.show();
	        }else{
	        	this.tree.root.reload();
	        	this.tree.show();
	        }
        }
        this.doQuery();
    },
    doQuery : function() {
		var treeFilter = new Ext.tree.TreeFilter(this.tree, {
			clearBlank : true,
			autoClear : true
		});
		this.tree.expandAll();
		var text = this.getEl().dom.value;
		var re = new RegExp(Ext.escapeRe(text), 'i'); // 制作正则表达式，'i'代表不区分大小写
		this.tree.root.cascade(function(n) { // 显示所有节点
			n.ui.show();
		});
		if (text != "") {
			treeFilter.filterBy(function(n) {
				// 如果函数返回true,那么该节点将保留否则它将被过滤掉
				return !n.isLeaf() || re.test(n.text);
			});
			// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
			this.tree.root.cascade(function(n) {
				if(n.id!='CatTreeRoot'){
					if(!n.isLeaf() && judge(n,re)==false && !re.test(n.text)){
						n.ui.hide();
					}
				}
			});
		} else {
			treeFilter.clear();
			this.onTrigger1Click();
			return;
		}
		// 过滤不匹配的非叶子节点或者是叶子节点
		function judge(n,re){
			var flag=false;
			n.cascade(function(n1){
				if(n1.isLeaf()){
					if(re.test(n1.text)){ flag=true;return; }
				} else {
					if(re.test(n1.text)){ flag=true;return; }
				}
			});
			return flag;
		}
	},
    getValue : function() {
        return typeof this.value != 'undefined' ? this.value : '';
    },
    clearValue : function() {
        if (this.hiddenField) {
            this.hiddenField.value = '';
        }
        this.setRawValue('');
        this.lastSelectionText = '';
        this.applyEmptyText();
    },
    readPropertyValue : function(obj, p) {
        var v = null;
        for (var o in obj) {
            if (o == p)
                v = obj[o];
        }
        return v;
    },
    setValue : function(obj) {
        if (!obj) {
            this.clearValue();
            return;
        }
        var v = obj;
        var text = v;
        var value = this.valueField || this.displayField;
        if (typeof v == "object" && this.readPropertyValue(obj, value)) {
            text = obj[this.displayField || this.valueField];
            v = obj[value];
        }
        var node = this.tree.getNodeById(v);
        if (node) {
            text = node.text;
        } else if (this.valueNotFoundText !== undefined) {
            text = this.valueNotFoundText;
        }
        this.lastSelectionText = text;
        if (this.hiddenField) {
            this.hiddenField.value = v;
        }
        Ext.tet.TreeComboField.superclass.setValue.call(this, text);
        this.value = v;
    },
    setEditable : function(value) {
        if (value == this.editable) {
            return;
        }
        this.editable = value;
        if (!value) {
            this.el.dom.setAttribute('readOnly', true);
            this.el.on('mousedown', this.onTriggerClick, this);
            this.el.addClass('x-combo-noedit');
        } else {
            this.el.dom.setAttribute('readOnly', false);
            this.el.un('mousedown', this.onTrigger2Click, this);
            this.el.removeClass('x-combo-noedit');
        }
    },
    choice : function(node, eventObject) {
        if (node.id != "CatTreeRoot")
            this.setValue(node.id);
        else
            this.clearValue();
        this.tree.hide();
    },
    onDestroy : function() {
        if (this.tree.rendered) {
            this.tree.getEl().remove();
        }
        Ext.tet.TreeComboField.superclass.onDestroy.call(this);
    },
    hideTree : function() {
        if (this.tree.rendered) {
            this.tree.hide();
        }
    }
});

Ext.reg('treecombo', Ext.tet.TreeComboField);
