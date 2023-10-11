var DrawingTools = (function() {
    //��������
    var getDom = function(id) {
        return document.getElementById(id)
    };
    var isNull = function(s) {
        return s == undefined || typeof(s) == 'undefined' || s == null || s == 'null' || s == '' || s.length < 1
    };
    var hideDefRM = function() {
        document.oncontextmenu = function() {
            //return false
        }
    }; //���������Ĭ������¼�
    /**��ͼ����*/
    var cbtCanvas;
    /**��ͼ����*/
    var cxt;
    /**���Ƶ�ͼ���б�*/
    var shapes = new Array();
    /**-1�����0������һ����1�ʣ�2������3�����Σ�4���Σ�5����Σ�6Բ��,21��ͷ��41ƽ���ı��Σ�42����*/
    var graphkind = {
        'clear': -1,
        'cancel': 0,
        'pen': 1,
        'line': 2,
        'trian': 3,
        'rect': 4,
        'poly': 5,
        'circle': 6,
        'arrow': 21,
        'parallel': 41,
        'trapezoid': 42
    };
    //����ͼƬ��������
    var bgPictureConfig = {
	    width:440,
	    height:440,
        pic: null,
        //����ͼƬ��ַ��·��
        repaint: true,
        //�Ƿ���Ϊ���ñ���ͼ��ÿ�����ʱ������ػ�
    };
    //���ز�����ͼƬ(src:ͼƬ·�����ַ),Ĭ���ػ汳��ͼ
    var loadPicture = function(src) {
        if (isNull(bgPictureConfig.repaint) || bgPictureConfig.repaint) {
            bgPictureConfig.pic = src
        }
        var img = new Image();
        img.onload = function() {
            cxt.drawImage(img,0,0,bgPictureConfig.width,bgPictureConfig.height)
        }
        img.src = src;
    }
    //��ͼ��������
    var paintConfig = {
        lineWidth: 1,
        //������ȣ�Ĭ��1
        strokeStyle: 'red',
        //������ɫ��Ĭ�Ϻ�ɫ
        fillStyle: 'red',
        //���ɫ
        lineJoin: "round",
        //����������ʽ��Ĭ��Բ��
        lineCap: "round",
        //����������ʽ��Ĭ��Բ��
        dataGrid:null,
        paintCount:1
    };
    //�������������ʽ
    var resetStyle = function() {
        cxt.strokeStyle = paintConfig.strokeStyle;
        cxt.lineWidth = paintConfig.lineWidth;
        cxt.lineJoin = paintConfig.lineJoin;
        cxt.lineCap = paintConfig.lineCap;
        cxt.fillStyle = paintConfig.fillStyle;
    }
    //���ͼ��
    var cursors = ['crosshair', 'pointer'];
    /** �л������ʽ*/
    var switchCorser = function(b) {
        cbtCanvas.style.cursor = ((isNull(b) ? isDrawing() : b) ? cursors[0] : cursors[1]);
    }
    //�������Ʊ�����
    var ctrlConfig = {
        kind: 1,
        //��ǰ�滭����
        isPainting: false,
        //�Ƿ�ʼ����
        startPoint: null,
        //��ʼ��
        cuGraph: null,
        //��ǰ���Ƶ�ͼ��
        cuPoint: null,
        //��ǰ��ʱ����㣬ȷ��һ�����������¹���
        cuAngle: null,
        //��ǰ��ͷ�Ƕ�
        vertex: [],
        //�����
    }
    /**��ȡ��ǰ�����*/
    var getCuPoint = function(i) {
        return ctrlConfig.cuPoint[i];
    }
    /**���õ�ǰ�����*/
    var setCuPoint = function(p, i) {
        return ctrlConfig.cuPoint[i] = p;
    }
    /**���õ�ǰ��ʱ�����ֵ*/
    var setCuPointXY = function(x, y, i) {
        if (isNull(ctrlConfig.cuPoint)) {
            var arr = new Array();
            arr[i] = new Point(x, y);
            ctrlConfig.cuPoint = arr;
        } else if (isNull(ctrlConfig.cuPoint[i])) {
            setCuPoint(new Point(x, y), i);
        } else {
            ctrlConfig.cuPoint[i].setXY(x, y);
        }
        return getCuPoint(i);
    }
    /**�Ƿ����ڻ���*/
    var isDrawing = function() {
        return ctrlConfig.isPainting;
    }
    /**��ʼ����״̬*/
    var beginDrawing = function() {
        ctrlConfig.isPainting = true;
    }
    /**��������״̬*/
    var stopDrawing = function() {
        ctrlConfig.isPainting = false;
    }
    /**�Ƿ��п�ʼ�����*/
    var hasStartPoint = function() {
        return ! isNull(ctrlConfig.startPoint);
    }
    /**���õ�ǰ���Ƶ�ͼ��*/
    var setCuGraph = function(g) {
        ctrlConfig.cuGraph = g;
    }
    /**��ȡ��ǰ���Ƶ�ͼ��*/
    var getCuGraph = function() {
        return ctrlConfig.cuGraph;
    }
    /**���ÿ�ʼ����㣨��������ʼ�㣬�����εĶ��㣬Բ�ε�Բ�ģ��ı��ε����Ͻǻ����½ǣ�����ε���ʼ�㣩*/
    var setStartPoint = function(p) {
        ctrlConfig.startPoint = p;
    }
    /**��ȡ��ʼ�����*/
    var getStartPoint = function() {
        return ctrlConfig.startPoint;
    }
    /**���ȫ��*/
    var clearAll = function() {
        cxt.clearRect(0, 0, cbtCanvas.width, cbtCanvas.height);
    }
    /**�ػ�*/
    var repaint = function() {
	    clearAll();
    }
    var drawingNumber = function(){
	    var p = getStartPoint();
		cxt.font = "18px serif";
        cxt.globalAlpha = 1; 
        cxt.strokeText(paintConfig.paintCount, p.getX(), p.getY());    
	}
    /**��������״̬ʱ������һ��datagrid������*/
    var addGridData = function(o) {
	    var id=cbtCanvas.id;
	    if(id.indexOf("front-pic")>-1){
			var BodyImage="����"; 
		}else if(id.indexOf("back-pic")>-1){
			var BodyImage="����"; 	
		}else{
			var BodyImage=""; 	
		}
		paintConfig.dataGrid.datagrid('insertRow',{
		    index: 0,   // ������0��ʼ
		    row: {
		        Id: paintConfig.paintCount,
		        BodyImageId:id,
		        BodyImage: BodyImage,
		        BodyPointDesc: "",
		        BodyNote:""
		    }
		});
		paintConfig.dataGrid.datagrid("sort","BodyImageId")
		createCanvas();
    }
    var createCanvas=function(){
	    var id=cbtCanvas.id;
	    PatBodyObj.CurHandleCanvasId=id;
	    var pid=document.getElementById(id).parentNode.id;
	    var canvasList = document.getElementById(pid);
	    var canvas = document.createElement('canvas');
	    canvas.id=id.split("-").slice(0,3).join("-")+"-c"+paintConfig.paintCount;
	    canvas.width = bgPictureConfig.width;
	    canvas.height = bgPictureConfig.height;
	    canvas.className="canvas-diagonal";
	    canvasList.appendChild(canvas);
	    
	    if(pid=="front-pic"){
			//PatBodyObj._f_drawUtil=new DrawingTools();
			var s=PatBodyObj._f_drawUtil.init({'id':canvas.id,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
		    if(s){
			    PatBodyObj._f_drawUtil.begin(ctrlConfig.kind);
				paintConfig.paintCount+=1; 
				rowIndexFocus(0,"BodyPointDesc");
			}
	    }else if(pid=="back-pic"){
		    //PatBodyObj._b_drawUtil=new DrawingTools();
			var s=PatBodyObj._b_drawUtil.init({'id':canvas.id,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
		    if(s){
			    PatBodyObj._b_drawUtil.begin(ctrlConfig.kind);
				paintConfig.paintCount+=1; 
				rowIndexFocus(0,"BodyPointDesc");
			}
		}else{
			var s=PatBodyObj._body_drawUtil.init({'id':canvas.id,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
		    if(s){
			    PatBodyObj._body_drawUtil.begin(ctrlConfig.kind);
				paintConfig.paintCount+=1; 
				rowIndexFocus(0,"BodyPointDesc");
			}
		}
	}
	var delLastCanvas=function(){
	    var id=cbtCanvas.id;
	    var pid=document.getElementById(id).parentNode.id;
	    canvas.id=id.split("-").slice(0,3).join("-")+"-c"+paintConfig.paintCount;
	    
	    if(pid=="front-pic"){
			//PatBodyObj._f_drawUtil=new DrawingTools();
			var s=PatBodyObj._f_drawUtil.init({'id':canvas.id,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
		    if(s){
			    PatBodyObj._f_drawUtil.begin(ctrlConfig.kind);
				paintConfig.paintCount-=1; 
				rowIndexFocus(0,"BodyPointDesc");
			}
	    }else if(pid=="back-pic"){
		    //PatBodyObj._b_drawUtil=new DrawingTools();
			var s=PatBodyObj._b_drawUtil.init({'id':canvas.id,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
		    if(s){
			    PatBodyObj._b_drawUtil.begin(ctrlConfig.kind);
				paintConfig.paintCount+=1; 
				rowIndexFocus(0,"BodyPointDesc");
			}
		}else{
		    //PatBodyObj._b_drawUtil=new DrawingTools();
			var s=PatBodyObj._body_drawUtil.init({'id':canvas.id,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
		    if(s){
			    PatBodyObj._body_drawUtil.begin(ctrlConfig.kind);
				paintConfig.paintCount+=1; 
				rowIndexFocus(0,"BodyPointDesc");
			}
		}
	}
    /**�㣨����,��ͼ�Ļ���Ҫ��,����x,y���꣩*/
    var Point = (function(x1, y1) {
        var x = x1,
        y = y1;
        return {
            set: function(p) {
                x = p.x,
                y = p.y;
            },
            setXY: function(x2, y2) {
                x = x2;
                y = y2;
            },
            setX: function(x3) {
                x = x3;
            },
            setY: function(y3) {
                y = y3;
            },
            getX: function() {
                return x;
            },
            getY: function() {
                return y;
            }
        }
    });
    /**����Σ������Ρ����Ρ�����Σ����ɶ�������*/
    var Poly = (function(ps1) {
        var ps = isNull(ps1) ? new Array() : ps1;
        var size = ps.length;
        return {
            set: function(ps2) {
                ps = ps2;
            },
            getSize: function() {
                return size;
            },
            setPoint: function(p, i) {
                if (isNull(p) && isNaN(i)) {
                    return;
                }
                ps[i] = p;
            },
            setStart: function(p1) {
                if (isNull(ps)) {
                    ps = new Array();
                    return ps.push(p1);
                } else {
                    ps[0] = p1;
                }
            },
            add: function(p) {
                if (isNull(ps)) {
                    ps = new Array();
                }
                return ps.push(p);
            },
            pop: function() {
                if (isNull(ps)) {
                    return;
                }
                return ps.pop();
            },
            shift: function() {
                if (isNull(ps)) {
                    return;
                }
                return ps.shift;
            },
            get: function() {
                if (isNull(ps)) {
                    return null;
                }
                return ps;
            },
            draw: function() {
                cxt.beginPath();
                for (i in ps) {
                    if (i == 0) {
                        cxt.moveTo(ps[i].getX(), ps[i].getY());
                    } else {
                        cxt.lineTo(ps[i].getX(), ps[i].getY());
                    }
                }
                cxt.closePath();
                cxt.stroke();
            }
        }
    });
    /*����(����������ɣ���������)*/
    var Line = (function(p1, p2, al) {
        var start = p1,
        end = p2,
        angle = al;
        var drawLine = function() {
            cxt.beginPath();
            cxt.moveTo(p1.getX(), p1.getY());
            cxt.lineTo(p2.getX(), p2.getY());
            cxt.stroke();
        }
        //����ͷ
        var drawArrow = function() {
            var vertex = ctrlConfig.vertex;
            var x1 = p1.getX(),
            y1 = p1.getY(),
            x2 = p2.getX(),
            y2 = p2.getY();
            var el = 50,
            al = 15;
            //�����ͷ�ױ������㣨��ʼ�㣬�����㣬���߽Ƕȣ���ͷ�Ƕȣ�
            vertex[0] = x1,
            vertex[1] = y1,
            vertex[6] = x2,
            vertex[7] = y2;
            //�������������X��֮��ļнǽǶ�ֵ
            var angle = Math.atan2(y2 - y1, x2 - x1) / Math.PI * 180;
            var x = x2 - x1,
            y = y2 - y1,
            length = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
            if (length < 250) {
                el /= 2,
                al / 2;
            } else if (length < 500) {
                el *= length / 500,
                al *= length / 500;
            }
            vertex[8] = x2 - el * Math.cos(Math.PI / 180 * (angle + al));
            vertex[9] = y2 - el * Math.sin(Math.PI / 180 * (angle + al));
            vertex[4] = x2 - el * Math.cos(Math.PI / 180 * (angle - al));
            vertex[5] = y2 - el * Math.sin(Math.PI / 180 * (angle - al));
            //��ȡ����������������
            x = (vertex[4] + vertex[8]) / 2,
            y = (vertex[5] + vertex[9]) / 2;
            vertex[2] = (vertex[4] + x) / 2;
            vertex[3] = (vertex[5] + y) / 2;
            vertex[10] = (vertex[8] + x) / 2;
            vertex[11] = (vertex[9] + y) / 2;
            //�������,��ʼ����
            cxt.beginPath();
            cxt.moveTo(vertex[0], vertex[1]);
            cxt.lineTo(vertex[2], vertex[3]);
            cxt.lineTo(vertex[4], vertex[5]);
            cxt.lineTo(vertex[6], vertex[7]);
            cxt.lineTo(vertex[8], vertex[9]);
            cxt.lineTo(vertex[10], vertex[11]);
            cxt.closePath();
            cxt.fill();
            cxt.stroke();
        }
        return {
            setStart: function(s) {
                start = s;
            },
            setEnd: function(e) {
                end = e;
            },
            getStart: function() {
                return start;
            },
            getEnd: function() {
                return end;
            },
            draw: function() {
                if (angle) {
                    drawArrow();
                } else {
                    drawLine();
                }
            }
        }
    });
    /**Բ��(����Բ�ĵ�Ͱ뾶)*/
    var Circle = (function(arr) {
        //������ʼ�㣨Բ�ģ��ͽ�����,�Լ�Բ�뾶
        var startPoint = arr.start,
        endPoint = arr.end,
        radius = arr.radius;
        /*����Բ*/
        var drawCircle = function() {
            cxt.beginPath();
            var x = startPoint.getX();
            var y = startPoint.getY();
            if (isNull(radius)) {
                radius = calculateRadius(startPoint, endPoint);
            }
            //x,y,�뾶,��ʼ��,������,˳ʱ��/��ʱ��
            cxt.arc(x, y, radius, 0, Math.PI * 2, false); // ����Բ
            cxt.stroke();
        }
        //����Բ�뾶
        var calculateRadius = function(p1, p2) {
            var width = p2.getX() - p1.getX();
            var height = p2.getY() - p1.getY();
            //����Ǹ���
            if (width < 0 || height < 0) {
                width = Math.abs(width);
            }
            //�����������=ƽ����(width^2+height^2)
            c = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2));
            return c;
        }
        return {
            set: function(params) {
                startPoint = params.start;
                endPoint = params.end;
                radius = params.radius;
            },
            setPoint: function(p1) {
                p = p1;
            },
            getPoint: function() {
                return p;
            },
            setRadius: function(r1) {
                radius = r1;
            },
            getRadius: function() {
                return radius;
            },
            calcRadius: calculateRadius,
            //����
            draw: drawCircle,
        }
    });
    /**�����������߷���*/
    var drawLine = function(p) {
        cxt.beginPath();
        cxt.moveTo(startPosition.getX(), startPosition.getY());
        cxt.lineTo(p.getX(), p.getY());
        cxt.stroke();
    }
    /**���������ι��߷���*/
    var drawTrian = function(ps) {
        cxt.beginPath();
        var a = ps.get();
        cxt.moveTo(a[0].getX(), a[0].getY());
        cxt.lineTo(a[1].getX(), a[1].getY());
        cxt.lineTo(a[2].getX(), a[2].getY());
        cxt.closePath();
        cxt.stroke();
    }
    /**���ƾ��ι��߷���*/
    var drawRect = function(p2) {
        var p = getStartPoint();
        var width = p.getX() - p2.getX();
        var height = p.getY() - p2.getY();
        cxt.beginPath();
        cxt.strokeRect(x, y, width, height); //���ƾ���
    }
    /*���ƶ���ι��߷���*/
    var drawpolygon = function(ps) {
        if (ps.length > 1) { //��ֻ֤�������������Ǿ���
            cxt.beginPath();
            var p = ctrlConfig.startPoint;
            var x = p.getX();
            var y = p.getY();
            cxt.moveTo(x, y);
            for (p1 in ps) {
                cxt.lineTo(p1.getX(), p1.getY());
            }
            cxt.stroke();
        }
    }
    /*����Բ�Ǿ��ι��߷���*/
    var drawRoundedRect = function(x, y, width, height, radius) {
        cxt.beginPath();
        cxt.moveTo(x, y + radius);
        cxt.lineTo(x, y + height - radius);
        cxt.quadraticCurveTo(x, y + height, x + radius, y + height);
        cxt.lineTo(x + width - radius, y + height);
        cxt.quadraticCurveTo(x + width, y + height, x + width, y + height - radius);
        cxt.lineTo(x + width, y + radius);
        cxt.quadraticCurveTo(x + width, y, x + width - radius, y);
        cxt.lineTo(x + radius, y);
        cxt.quadraticCurveTo(x, y, x, y + radius);
        cxt.stroke();
    }
    /*����Բ���߷���*/
    var drawCircle = function(c) {
        var p = c.getPoint(); //�����
        var x = p.getX();
        var y = p.getY();
        var r = c.getRadius();
        cxt.beginPath();
        //x,y,�뾶,��ʼ��,������,˳ʱ��/��ʱ��
        cxt.arc(x, y, r, 0, Math.PI * 2, false); // ����Բ
        cxt.stroke();
    }
    //����Բ�뾶���߷���
    var calculateRadius = function(p1, p2) {
        var width = p2.getX() - p1.getX();
        var height = p2.getY() - p1.getY();
        //����Ǹ���
        if (width < 0 || height < 0) {
            width = Math.abs(width);
        }
        //�����������=ƽ����(width^2+height^2)
        c = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2));
        return c;
    }
    //��갴��������״ε��ȷ����ʼ����㣬�϶���겻�Ͻ���ͼ���ػ棩
    var mouseDown = function(e) {
        var btnNum = e.button;
        if (btnNum == 0) {
            //console.log("mouseDownѡ��" + ctrlConfig.kind);
            //������ʼ��
            switch (ctrlConfig.kind) {
            case graphkind.pen:
                //����(���ɿ���갴��һֱ��)
                beginDrawing(); //��ʼ����
                var p = new Point(e.offsetX, e.offsetY);
                setStartPoint(p);
                cxt.beginPath();
                cxt.moveTo(e.offsetX, e.offsetY);
                break;
            case graphkind.poly:
                //�����
                var p = new Point(e.offsetX, e.offsetY);
                if (isDrawing()) {
                    getCuGraph().add(p); //��ӵ�
                } else { //��һ��ȷ����ʼ����
                    beginDrawing(); //��ʼ����
                    setStartPoint(p);
                    var poly = new Poly();
                    poly.add(p);
                    setCuGraph(poly); //���õ�ǰ����ͼ��
                }
                break;
            case graphkind.line:
                //����
            case graphkind.arrow:
                //����
            case graphkind.trian:
                //������
            case graphkind.rect:
                //����
            case graphkind.parallel:
                //ƽ���ı���
            case graphkind.trapezoid:
                //����
                beginDrawing(); //��ʼ����
                var p = new Point(e.offsetX, e.offsetY);
                setStartPoint(p);
                var poly = new Poly();
                poly.add(p);
                setCuGraph(poly); //���õ�ǰ����ͼ��
                break;
            case graphkind.circle:
                //Բ
                //console.log("ȷ��ͼ�λ��ƿ�ʼ����㣺" + e.offsetX + "," + e.offsetY); //���ȷ��ͼ�εĿ�ʼ�����
                beginDrawing(); //��ʼ����
                var p = new Point(e.offsetX, e.offsetY);
                setStartPoint(p);
                var circle = new Circle({
                    'start': p
                });
                setCuGraph(circle);
                break;
            case ctrlConfig.cursor:
                //�������
            default:
                //Ĭ����������꣬���������
            }
        } else if (btnNum == 2) {
            //console.log("�Ҽ����ڽ�������λ���");
            if (isDrawing()) {
                if (ctrlConfig.kind == graphkind.poly) {
                    repaint();
                    getCuGraph().draw();
                    drawingNumber();
                    stopDrawing(); //��������
                    addGridData();
                }
            }
        }
        hideDefRM(); //���������Ĭ���¼�
    }
    //����ƶ����϶�����������ƶ���λ�ò����ػ�ͼ�Σ�
    var mouseMove = function(e) {
	    var d=isDrawing();
	    var s=hasStartPoint();
	    //console.log("d:"+d+",s:"+s+",kind"+ctrlConfig.kind)
        if (d && s) { //����Ƿ�ʼ���ƣ�����Ƿ��п�ʼ�����
            //���ʲ���Ҫ�ػ�
            //����ƶ�����Ҫ�ػ棬������Ҫ�ػ�֮ǰ�Ļ���
            if (ctrlConfig.kind > 1) {
                repaint(); //�ػ�
            }
            var p = setCuPointXY(e.offsetX, e.offsetY, 0); //���ù������ʱ����㣬���ڷ�ֹ�ظ���������
            //console.log("p:"+e.offsetX+","+e.offsetY)
            switch (ctrlConfig.kind) {
            case graphkind.pen:
                //����(һֱ��)
                cxt.lineTo(e.offsetX, e.offsetY);
                cxt.stroke();
                break;
            case graphkind.poly:
                //�����
                var poly = getCuGraph(poly);
                var size = poly.getSize();
                poly.setPoint(p, (size - 1));
                poly.draw();
                break;
            case graphkind.line:
                //����
                var line = new Line(getStartPoint(), p, false);
                ctrlConfig.cuGraph = line;
                line.draw();
                break;
            case graphkind.arrow:
                //����
                var line = new Line(getStartPoint(), p, true);
                ctrlConfig.cuGraph = line;
                line.draw();
                break;
            case graphkind.trian:
                //������
                var lu = getStartPoint();
                var x2 = p.getX();
                var x1 = lu.getX();
                //��������ߵĵ�������㷽��:(x1-(x2-x1),y2)
                var x3 = x1 - (x2 - x1);
                var l = setCuPointXY(x3, p.getY(), 1); //���ù������ʱ����㣬���ڷ�ֹ�ظ���������
                var poly = getCuGraph(); //��ȡ��ǰͼ��
                poly.set([lu, p, l]);
                poly.draw(); //��ʱ����
                break;
            case graphkind.parallel:
                //ƽ���ı���
                var lu = getStartPoint();
                var x3 = p.getX();
                var x1 = lu.getX();
                //ƽ���ı�������δ֪�������㷽��:(x1-(x3-x1),y3),(x1+(x3-x1),y1)
                var x2 = x3 + (x3 - x1);
                var x4 = x1 - (x3 - x1);
                var ld = setCuPointXY(x2, lu.getY(), 1); //���ù������ʱ����㣬���ڷ�ֹ�ظ���������
                var ru = setCuPointXY(x4, p.getY(), 2); //���ù������ʱ����㣬���ڷ�ֹ�ظ���������
                var poly = getCuGraph(); //��ȡ��ǰͼ��
                poly.set([lu, ru, p, ld]);
                poly.draw(); //��ʱ����
                break;
            case graphkind.trapezoid:
                //����
                var lu = getStartPoint();
                var x3 = p.getX();
                var x1 = lu.getX();
                //��������δ֪�������㷽��:(x3-(x3-x1)/2,y1),(x1-(x3-x1)/2,y3)
                var x2 = x3 - (x3 - x1) / 2;
                var x4 = x1 - (x3 - x1) / 2;
                var ld = setCuPointXY(x2, lu.getY(), 1);
                var ru = setCuPointXY(x4, p.getY(), 2);
                var poly = getCuGraph();
                poly.set([lu, ru, p, ld]);
                poly.draw();
                break;
            case graphkind.rect:
                //����
                var lu = getStartPoint();
                //�������ϽǺ����Ͻ�������㷽��
                var ld = setCuPointXY(lu.getX(), p.getY(), 1);
                var ru = setCuPointXY(p.getX(), lu.getY(), 2);
                var poly = getCuGraph();
                poly.set([lu, ru, p, ld]);
                poly.draw();
                break;
            case graphkind.circle:
                //Բ
                var circle = getCuGraph(); //��ȡ��ǰͼ��
                circle.set({
                    'start': getStartPoint(),
                    'end': p
                });
                circle.draw(); //��ʱ����
                break;
            }
        }
    }
    //��갴���ɿ�
    var mouseUp = function(e) {
        if (isDrawing()) {
            //console.log("�ɿ���갴��:"+e.offsetX+","+e.offsetY);
            //���ʲ���Ҫ�ػ�
            if (ctrlConfig.kind > 1) {
                //repaint();
                getCuGraph().draw();
            }
            if (ctrlConfig.kind != graphkind.poly) { //����λ�����갴���ɿ����������ƣ������ֻ���Ҽ�������ܽ�������
                drawingNumber()
                stopDrawing(); //��������
                addGridData();
            }
        }
    }
    //����Ƴ�
    var mouseOut = function(e) {
        //console.log("����Ƴ���������" + e.offsetX + "," + e.offsetY);
        if (isDrawing()) {
            //console.log("ֹͣ����");
            if (ctrlConfig.kind > 1) {
                repaint();
                getCuGraph().draw();
            }
            drawingNumber();
            stopDrawing(); //ֹͣ����
            addGridData();
        }
    }
    return {
        isNull: isNull,
        getDom: getDom,
        clear: function() {
            stopDrawing(); //ֹͣ����
            repaint();
        },
        /**��ʼ��*/
        init: function(params) {
            cbtCanvas = getDom(params.id);
            paintConfig.dataGrid=params.dataGrid;
            //������Ƿ�֧��Canvas
            if (cbtCanvas.getContext) {
                /**��ͼ����*/
                cxt = cbtCanvas.getContext("2d");
                cbtCanvas.onmousedown = mouseDown;
                cbtCanvas.onmouseup = mouseUp;
                cbtCanvas.onmousemove = mouseMove;
                cbtCanvas.onmouseout = mouseOut;
                resetStyle(); //������ʽ
                return true;
            } else {
                return false;
            }
        },
        reInit: function(params) {
	        var s=this.init(params)
	        if(s){
		        if(isNaN(params.paintCount)){
	        		paintConfig.paintCount-=1; 
		        }else{
			    	paintConfig.paintCount=params.paintCount;
			    }
	        	var id=cbtCanvas.id.split("-").slice(0,3).join("-")+"-c"+(paintConfig.paintCount-2);
	    		PatBodyObj.CurHandleCanvasId=id;
	        }
	        return s;
        },
        /**���ñ���ͼƬ*/
        setBgPic: loadPicture,
        /**ѡ��ͼ������*/
        begin: function(k) {
            //console.log("ѡ�����ͼ�Σ�" + k);
            if (isNaN(k)) { //����������֣���ת��Ϊ��Ӧ�ַ�
                ctrlConfig.kind = kind[k];
            } else {
                ctrlConfig.kind = k;
            }
            switchCorser(true); //�л������ʽ
        },
        penColor: function(pc) {
            //console.log("�޸���ɫ:" + pc);
            paintConfig.strokeStyle = pc;
            resetStyle();
        },
        /*���ͣ���ֹͣ��ͼ*/
        hand: function() {
            ctrlConfig.kind = 0;
            stopDrawing(); //ֹͣ����
            switchCorser(false); //�л������ʽ
        }
    }
})