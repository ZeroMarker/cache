/**
 * @version Base on Ext3.0
 * @class Ext.ux.TreeCombo
 * @extends Ext.form.TriggerField
 */
Ext.namespace("Ext.ux");
Ext.ux.TreeCombo= Ext.extend(Ext.form.TriggerField, {
	triggerClass: 'x-form-tree-trigger',
	labelSeparator:"",
	enableKeyEvents:true,
	initComponent : function() {
		//this.readOnly = true;
		Ext.ux.TreeCombo.superclass.initComponent.call(this);
		
		this.on('specialkey', function(f, e) {
					if (e.getKey() == e.ENTER) {
						this.onTriggerClick();
					}
				}, this);
		this.getTree();
	},
	onTriggerClick : function() {
	   if(!this.disabled){
	   	   //this.treePanel.root.reload();
	       this.getTree().show();  
	       this.getTree().getEl().alignTo(this.wrap, 'tl-bl?');  
	   }
	   this.doQuery();
	},
	getTree : function() {
		if (!this.treePanel) {
			if (!this.treeWidth) {
				this.treeWidth = Math.max(250, this.width || 200);
			}
			if (!this.treeHeight) {
				this.treeHeight = 200;
			}
			this.treePanel = new Ext.tree.TreePanel({
				renderTo : Ext.getBody(),
				loader : this.loader || new Ext.tree.TreeLoader({
							/*preloadChildren : (typeof this.root == 'undefined'),*/
							url : this.dataUrl || this.url
						}),
				root : this.root || new Ext.tree.AsyncTreeNode({
							children : this.children
						}),
				rootVisible : (typeof this.rootVisible != 'undefined')
						? this.rootVisible
						: (this.root ? true : false),
				floating : true,
				autoScroll : true,
				minWidth : 200,
				minHeight : 200,
				width : this.treeWidth,
				height : this.treeHeight,
				listeners : {
					hide : this.onTreeHide,
					show : this.onTreeShow,
					click : this.onTreeNodeClick,
					expandnode : this.onExpandOrCollapseNode,
					collapsenode : this.onExpandOrCollapseNode,
					resize : this.onTreeResize,
					scope : this
				}				
			});
			this.treePanel.show();
			this.treePanel.hide();
			/*this.relayEvents(this.treePanel.loader, ['beforeload', 'load',
							'loadexception']);*/
			if (this.resizable) {
				this.resizer = new Ext.Resizable(this.treePanel.getEl(), {
							pinned : true,
							handles : 'se'
						});
				this.mon(this.resizer, 'resize', function(r, w, h) {
							this.treePanel.setSize(w, h);
						}, this);
			}
		}
		return this.treePanel;
	},
	onExpandOrCollapseNode : function() {
		if (!this.maxHeight || this.resizable)
			return; // -----------------------------> RETURN
		var treeEl = this.treePanel.getTreeEl();
		var heightPadding = treeEl.getHeight() - treeEl.dom.clientHeight;
		var ulEl = treeEl.child('ul'); // Get the underlying tree element
		var heightRequired = ulEl.getHeight() + heightPadding;
		if (heightRequired > this.maxHeight)
			heightRequired = this.maxHeight;
		this.treePanel.setHeight(heightRequired);
	},

	onTreeResize : function() {
		if (this.treePanel)
			this.treePanel.getEl().alignTo(this.wrap, 'tl-bl?');
	},

	onTreeShow : function() {
		Ext.getDoc().on('mousewheel', this.collapseIf, this);
		Ext.getDoc().on('mousedown', this.collapseIf, this);
	},

	onTreeHide : function() {
		Ext.getDoc().un('mousewheel', this.collapseIf, this);
		Ext.getDoc().un('mousedown', this.collapseIf, this);
	},

	collapseIf : function(e) {
		if (!e.within(this.wrap) && !e.within(this.getTree().getEl())) {
			this.collapse();
		}
	},

	collapse : function() {
		this.getTree().hide();
		if (this.resizer)
			this.resizer.resizeTo(this.treeWidth, this.treeHeight);
	},

	// private
	validateBlur : function() {
		return !this.treePanel || !this.treePanel.isVisible();
	},
	beforeBlur : function(){
		if (this.getRawValue()==""){
    		this.clearValue();
    	}
    },
	setValue : function(v) {
		this.startValue = this.value = v;
		if (this.treePanel) {
			var n = this.treePanel.getNodeById(v);
			if (n) {
				n.select();
				this.setRawValue(n.text);
				if (this.hiddenField)
					this.hiddenField.value = v;
			}else{
				if (this.hiddenField)
					this.hiddenField.value = v;
				this.setRawValue(v);
			}
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
        this.value='';
    },
    /*assertValue  : function(){
    },*/
	onTreeNodeClick : function(node, e) {
		if (node.id != "CatTreeRoot"){
			this.setRawValue(node.text);
			this.value = node.id;
			if (this.hiddenField)
				this.hiddenField.value = node.id;
			this.fireEvent('select', this, node);
			this.collapse();
		}
	},
	onRender : function(ct, position) {
		Ext.ux.TreeCombo.superclass.onRender.call(this, ct, position);
		if (this.hiddenName) {
			this.hiddenField = this.el.insertSibling({
						tag : 'input',
						type : 'hidden',
						name : this.hiddenName,
						id : (this.hiddenId || this.hiddenName)
					}, 'before', true);
			// prevent input submission
			this.el.dom.removeAttribute('name');
		}
		this.treePanel.render(Ext.getBody());
	},
	onKeyUp : function() {
		if(!this.disabled){
	       this.getTree().show();  
	       this.getTree().getEl().alignTo(this.wrap, 'tl-bl?');  
	   }  
        this.doQuery();
    },
    doQuery : function() {
		var treeFilter = new Ext.tree.TreeFilter(this.treePanel, {
			clearBlank : true,
			autoClear : true
		});
		this.treePanel.expandAll();
		var text = this.getEl().dom.value;
		var re = new RegExp(Ext.escapeRe(text), 'i'); // 制作正则表达式，'i'代表不区分大小写
		this.treePanel.root.cascade(function(n) { // 显示所有节点
			n.ui.show();
		});
		if (text != "") {
			treeFilter.filterBy(function(n) {
				// 如果函数返回true,那么该节点将保留否则它将被过滤掉
				return !n.isLeaf() || re.test(n.text);
			});
			// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
			this.treePanel.root.cascade(function(n) {
				if(n.id!='CatTreeRoot'){
					if(!n.isLeaf() && judge(n,re)==false && !re.test(n.text)){
						
						n.ui.hide();
					}
				}
			});
		} else {
			treeFilter.clear();
			this.clearValue();
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
	onDestroy : function() {
        if (this.treePanel.rendered) {
            this.treePanel.getEl().remove();
        }
        Ext.ux.TreeCombo.superclass.onDestroy.call(this);
    }
});
Ext.reg('treecombox', Ext.ux.TreeCombo);