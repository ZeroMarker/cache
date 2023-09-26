/**
  *name:ColumnNodeUI of hospreport
  *author:limingzhong
  *Date:2009-5-22
 */

var index="";

Ext.tree.ColumnTree = Ext.extend(Ext.tree.TreePanel,{
    lines:true,
    borderWidth:Ext.isBorderBox ? 0:2, // the combined left/right border for each cell
    cls:'x-column-tree',
    onRender : function(){
        Ext.tree.ColumnTree.superclass.onRender.apply(this, arguments);
        this.headers = this.body.createChild({cls:'x-tree-headers'},this.innerCt.dom);
        var cols = this.columns, c;
        var totalWidth = 0;
        for(var i = 0, len = cols.length; i < len; i++){
            c = cols[i];
			//对列头隐藏很关键
			if(typeof c.hidden == 'undefined' || c.hidden === false){ 
				totalWidth += c.width;
				this.headers.createChild({
					cls:'x-tree-hd ' + (c.cls?c.cls+'-hd':''),
					cn: {
						cls:'x-tree-hd-text',
						html: c.header
					},
					style:'width:'+(c.width-this.borderWidth)+'px;'
				});
			}
        }
        this.headers.createChild({cls:'x-clear'});
        this.headers.setWidth(totalWidth);
        this.innerCt.setWidth(totalWidth);
    }
});

Ext.tree.ColumnNodeUI = Ext.extend(Ext.tree.TreeNodeUI, {
    focus: Ext.emptyFn, // prevent odd scrolling behavior
    renderElements : function(n, a, targetNode, bulkRender){
        this.indentMarkup = n.parentNode ? n.parentNode.ui.getChildIndent() : '';
        var t = n.getOwnerTree();
        var cols = t.columns;
        var bw = t.borderWidth;
        var c = cols[0];
        var buf = [
            '<li class="x-tree-node"><div ext:tree-node-id="',n.id,'" class="x-tree-node-el x-tree-node-leaf ', a.cls,'">',
                '<div class="x-tree-col" style="width:',c.width-bw,'px;">',
                    '<span class="x-tree-node-indent">',this.indentMarkup,"</span>",
                    '<img src="', this.emptyIcon, '" class="x-tree-ec-icon x-tree-elbow">',
                    '<img src="', a.icon || this.emptyIcon, '" class="x-tree-node-icon',(a.icon ? " x-tree-node-inline-icon" : ""),(a.iconCls ? " "+a.iconCls : ""),'" unselectable="on">',
                    '<a hidefocus="on" class="x-tree-node-anchor" href="',a.href ? a.href : "#",'" tabIndex="1" ',
                    a.hrefTarget ? ' target="'+a.hrefTarget+'"' : "", '>',
                    '<span unselectable="on">', n.text || (c.renderer ? c.renderer(a[c.dataIndex], n, a) : a[c.dataIndex]),"</span></a>",
                "</div>"];
         for(var i = 1, len = cols.length; i < len; i++){
            c = cols[i];
			//对列头隐藏很关键
			if(i>3){
				if (typeof c.hidden == 'undefined' || c.hidden === false){ 
					 buf.push('<div class="x-tree-col ',(c.cls?c.cls:''),'" style="width:',c.width-bw,'px;">',
								'<div class="x-tree-col-float">',(c.renderer ? c.renderer(a[c.dataIndex], n, a) : a[c.dataIndex]),"</div>",
							  "</div>");
				}
			}else{
				if (typeof c.hidden == 'undefined' || c.hidden === false){ 
					 buf.push('<div class="x-tree-col ',(c.cls?c.cls:''),'" style="width:',c.width-bw,'px;">',
								'<div class="x-tree-col-text">',(c.renderer ? c.renderer(a[c.dataIndex], n, a) : a[c.dataIndex]),"</div>",
							  "</div>");
				}
			}
         }
         buf.push(
            '<div class="x-clear"></div></div>',
            '<ul class="x-tree-node-ct" style="display:none;"></ul>',
            "</li>");

        if(bulkRender !== true && n.nextSibling && n.nextSibling.ui.getEl()){
            this.wrap = Ext.DomHelper.insertHtml("beforeBegin",n.nextSibling.ui.getEl(), buf.join(""));
        }else{
            this.wrap = Ext.DomHelper.insertHtml("beforeEnd", targetNode, buf.join(""));
        }

        this.elNode = this.wrap.childNodes[0];
        this.ctNode = this.wrap.childNodes[1];
        var cs = this.elNode.firstChild.childNodes;
        this.indentNode = cs[0];
        this.ecNode = cs[1];
        this.iconNode = cs[2];
        this.anchor = cs[3];
        this.textNode = cs[3].firstChild;
    }
});

Ext.tree.ColumnTreeEditor = function(tree, config){
   config = config||{};
   var field = config.events?config:new Ext.form.TextField(config);
   Ext.tree.TreeEditor.superclass.constructor.call(this, field);
   this.tree = tree;
   if(!tree.rendered){
       tree.on('render', this.initEditor, this);
   }else{
       this.initEditor(tree);
   }
};

Ext.extend(Ext.tree.ColumnTreeEditor, Ext.Editor, {
	alignment: "l-l",
	autoSize: false,
	hideEl : false,
	cls: "x-small-editor x-tree-editor",
	shim:false,
	shadow:"frame",
	maxWidth: 100,
	editDelay: 0,
	initEditor:function(tree){
		tree.on('beforeclick', this.beforeNodeClick, this);
		tree.on('triggeredit', this.triggerEdit, this); //自己添加
		tree.on('click', this.triggerEdit, this); //自己添加
		this.on('complete', this.updateNode, this);
		this.on('beforestartedit', this.fitToTree, this);
		this.on('startedit', this.bindScroll, this, {delay:10});
		this.on('specialkey', this.onSpecialKey, this);
		
		
	},
	
    fitToTree : function(ed, el){
		var td = this.tree.getTreeEl().dom, nd = el.dom;
		if(td.scrollLeft >  nd.offsetLeft){             td.scrollLeft = nd.offsetLeft;
		}
		var w = Math.min(
			this.maxWidth,
			(td.clientWidth > 20 ? td.clientWidth : td.offsetWidth) - Math.max(0, nd.offsetLeft-td.scrollLeft) - 50);
		this.setSize(w,'');
	},

	//===========================================================================
	 
	startCellEdit:function(cell, node) {
        if (cell.colModel.isCellEditable( cell.col )) {
          var dataIndex = cell.colModel.getDataIndex( cell.col );
		  this.dataIndex = dataIndex;
		 
          this.boundEl = cell;

          var v = node.attributes[dataIndex] !== undefined ? node.attributes[dataIndex] : this.boundEl.dom.innerHTML;
          var e =
              {
                dataIndex:dataIndex,
                value:v,
                column:cell.col
              };

          if (this.fireEvent( "beforeedit", e ) !== false && ! e.cancel) {
            var ed = cell.colModel.getCellEditor( cell.col );

            if (! ed.rendered) {
              ed.render(ed.parentEl || document.body);

              if (ed.autoSize) {
                var sz = this.boundEl.getSize();

                switch (ed.autoSize) {
                  case "width":
                   ed.setSize(sz.width, "");
                   break;

                  case "height":
                   ed.setSize("", sz.height);
                   break;

                  default: ed.setSize(sz.width, sz.height);
                }
              }
            }
            ed.el.alignTo(this.boundEl, this.alignment);
            this.activeEditor = ed;
            this.editing = true;
            this.editNode = node;
			
            this.dataIndex = dataIndex;
			
            ed.on("specialkey", this.onCellEditorKey, this);
            ed.on("complete", this.onCellEditComplete, this);
            ed.on("complete", function() {

              if (op == cell.colModel.config[cell.col].operator) {
                this.initOperator(op, this.editNode, cell);
              }
            }, this);

            ed.startEdit(this.boundEl, node.attributes[dataIndex]);
          }
        }
    },

	//===========================================================================
	
	triggerEdit:function(node, e){
		if(node.attributes.leaf=="aaa"){ //非叶子节点不允许修改
			var obj = e.target;
			if (Ext.select(".x-tree-node-anchor", false, obj).getCount() == 1) {
				obj = Ext.select(".x-tree-node-anchor", false, obj).elements[0].firstChild;
			}else if (obj.nodeName == 'SPAN' || obj.nodeName == 'DIV'){
				obj = e.target;
			}else{
				return false;
			}
			var colIndex = 0;
			for (var i=5;i<this.tree.columns.length;i++){
				if(node.attributes[this.tree.columns[i].dataIndex] == obj.innerHTML){
					colIndex = i;
				}
				index=i;
			}
			this.completeEdit();
			this.editNode = node;
			this.editCol = obj;
			this.editColIndex = colIndex;
			this.startEdit(obj);
			if (obj.nodeName == 'DIV') {
				var width = obj.offsetWidth;
				this.setSize(width);
			}
			return this.editColIndex;
		}
	},	
	
    bindScroll:function(){
		this.tree.getTreeEl().on('scroll', this.cancelEdit, this);
	},

    beforeNodeClick:function(node, e){
		var sinceLast = (this.lastClick ? this.lastClick.getElapsed() : 0);
		this.lastClick = new Date();
		if(sinceLast > this.editDelay && this.tree.getSelectionModel().isSelected(node)){
			e.stopEvent();
			this.triggerEdit(node, e);
			return false;
		}else {
			this.completeEdit();
		}
	},

    onSpecialKey:function(field, e){
		var k = e.getKey();
		if(k == e.ESC){
			e.stopEvent();
			this.cancelEdit();
		}else if(k == e.ENTER && !e.hasModifier()){
			e.stopEvent();
			this.completeEdit();
		}
	},
	
	
	updateNode:function(ed, value){
		this.tree.getTreeEl().un('scroll',this.cancelEdit,this);
		this.editCol.innerHTML = value;
	},
	

	onHide:function(){
		Ext.tree.TreeEditor.superclass.onHide.call(this);
		if(this.editNode){
			this.editNode.ui.focus();
		}
	}
});

