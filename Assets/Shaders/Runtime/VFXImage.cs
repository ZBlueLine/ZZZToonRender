using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Profiling;
using UnityEngine.Sprites;
using UnityEngine.UI;
/// <summary>
/// ����UGUIMesh Ϊ��VFX����UGUI atlas ����һ�ɽ�ԭʼUV���浽uv0.zw
/// </summary>
[ExecuteAlways]
[RequireComponent(typeof(Graphic))]
public class VFXImage : BaseMeshEffect, IMaterialModifier
{
    [Header("Mesh")]
    public Mesh CustomMesh;
    public bool UV2;
    [SerializeField]
	private bool animatable;
#region ColorAdjust
	[SerializeField]
	private bool colorAdjust;
	//[Range(-1,1)]
	//public float  Hue;
	[Range(-1,1)]
	public float  Saturation;
	[Range(-1,1)]
	public float  Brightness;
	[Range(-1,1)]
	public float  Contrast;
	[Tooltip("DONT change this sharedMaterial unless u know what ur doing")]
	public Material sharedMat_ColorAdjust;
#endregion
    public override void ModifyMesh(VertexHelper toFill)
    {
        if (!this.IsActive()) return;
        if (this.graphic == null) return;
        if (CustomMesh && CustomMesh.isReadable)
        {
            GenerateCustomMesh((graphic is Image image) ? image.overrideSprite : null, CustomMesh, toFill);
        }
        else
        {
            GenerateLegcyMesh((graphic is Image image) ? image.overrideSprite : null, toFill);
        }
	    ApplyVFXControllers(toFill);
    }
	void ApplyVFXControllers(VertexHelper toFill)
	{
		if(colorAdjust)
		{
			//we save adjust params in uv1.xyz .this only works in (UI/ColorAdjust.shader)
			if(graphic.canvas&&!graphic.canvas.additionalShaderChannels.HasFlag(AdditionalCanvasShaderChannels.TexCoord1))
			{
				graphic.canvas.additionalShaderChannels |= AdditionalCanvasShaderChannels.TexCoord1;
			}
			UIVertex vert = new UIVertex();
			
			for (int i = 0; i < toFill.currentVertCount; i++)
			{
				toFill.PopulateUIVertex(ref vert, i);
				vert.uv1.x=Contrast;
				vert.uv1.y = Mathf.Clamp(Saturation,-1,0.99f);
				vert.uv1.z =Brightness;
				vert.uv1.w =1;
				toFill.SetUIVertex(vert, i);
			}
			
		}
	}
    void GenerateLegcyMesh(Sprite sprite, VertexHelper toFill)
    {
        Vector4 spriteUV = sprite ? DataUtility.GetOuterUV(sprite) : new Vector4(0, 0, 1, 1);
        float w = spriteUV.z - spriteUV.x;
        float h = spriteUV.w - spriteUV.y;
        UIVertex vert = new UIVertex();
        for (int i = 0; i < toFill.currentVertCount; i++)
        {
            toFill.PopulateUIVertex(ref vert, i);
            vert.uv0.z = (vert.uv0.x - spriteUV.x) / w;
            vert.uv0.w = (vert.uv0.y - spriteUV.y) / h;
            toFill.SetUIVertex(vert, i);
        }
    }
    void GenerateCustomMesh(Sprite sprite, Mesh mesh, VertexHelper toFill)
    {
        var vertices = mesh.vertices;
        var triangles = mesh.triangles;
        var normals = mesh.normals;
        if (normals.Length != vertices.Length)
        {
            normals = new Vector3[vertices.Length];
        }
        var tangents = mesh.tangents;
        if (tangents.Length != vertices.Length)
        {
            tangents = new Vector4[vertices.Length];
        }
        var colors = mesh.colors;
        if (colors.Length != colors.Length)
        {
            colors = new Color[vertices.Length];
            for (int i = 0; i < colors.Length; i++)
            {
                colors[i] = graphic.color;
            }
        }
        ///handle sprite UV
        var meshUV = mesh.uv;
        var uv0 = new Vector4[vertices.Length];
        var uv1 = mesh.uv2;
        if (!UV2 || uv1.Length != meshUV.Length)
        {
            uv1 = meshUV;
        }
        Vector4 spriteUV = sprite ? DataUtility.GetOuterUV(sprite) : new Vector4(0, 0, 1, 1);
        Vector2 spriteOffset = new Vector2(spriteUV.x, spriteUV.y);
        Vector2 spriteSize = new Vector2(spriteUV.z, spriteUV.w) - spriteOffset;
        if (meshUV.Length != vertices.Length) { Debug.LogError("no enough uv index in mesh:" + mesh); return; }
        for (int i = 0; i < vertices.Length; i++)
        {
            var uvSprite = spriteOffset + meshUV[i] * spriteSize;
            uv0[i] = new Vector4(uvSprite.x, uvSprite.y, uv1[i].x, uv1[i].y);
        }
        //uv = mesh.uv;
        toFill.Clear();
        Vector4 vector = Vector4.zero;
        Vector2 vector2 = Vector2.one;
        Rect pixelAdjustedRect = this.graphic.GetPixelAdjustedRect();
        int num = Mathf.RoundToInt(vector2.x);
        int num2 = Mathf.RoundToInt(vector2.y);
        Vector4 vector3 = new Vector4(vector.x / (float)num, vector.y / (float)num2, ((float)num - vector.z) / (float)num, ((float)num2 - vector.w) / (float)num2);
        var drawingDimensions = new Vector4(pixelAdjustedRect.x + pixelAdjustedRect.width * vector3.x, pixelAdjustedRect.y + pixelAdjustedRect.height * vector3.y, pixelAdjustedRect.x + pixelAdjustedRect.width * vector3.z, pixelAdjustedRect.y + pixelAdjustedRect.height * vector3.w);
        float width = Mathf.Abs(drawingDimensions.z) + Mathf.Abs(drawingDimensions.x);
        float height = Mathf.Abs(drawingDimensions.w) + Mathf.Abs(drawingDimensions.y);
        for (int i = 0; i < vertices.Length; i++)
        {
            toFill.AddVert(
                new Vector3(vertices[i].x * width, vertices[i].y * height, vertices[i].z * width),
                (colors.Length > i) ? colors[i] * graphic.color : graphic.color,
                uv0[i], Vector4.zero,
                normals[i], tangents[i]);
        }
        for (int i = 0; i < triangles.Length; i += 3)
        {
            toFill.AddTriangle(triangles[i], triangles[i + 1], triangles[i + 2]);
        }
    }

    /// <summary>
    /// CanvasRenderer ��֧������materialPropBlock ���Ҳ�޷�k֡
    /// ���ǵ�K���ʶ��������� ���������Ҫ֧�ֶ�����UI ����һ��������matʵ��
    /// </summary>
    /// <param name="baseMaterial"></param>
    /// <returns></returns>
    public Material GetModifiedMaterial(Material baseMaterial)
	{
		if(!this.isActiveAndEnabled)return baseMaterial;
		//ColorAdjust not support animation
		if(colorAdjust)
		{
			return sharedMat_ColorAdjust;
		}
        if (Animatable)
        {
            RequireAnim(baseMaterial);
            return mat_anim;
        }
        else
        {
            ReleaseAnim(!Animatable);
        }
        return baseMaterial;
    }
    #region Anims
    public bool Animatable
    {
        get
	    {
		    //TODO:ColorAdjust shader NOT support animation yet
	        return animatable&&!colorAdjust;
        }
        set
        {
            animatable = value;
            if (animatable)
            {
                RequireAnim(this.graphic.material);
            }
            else
            {
                ReleaseAnim(!Animatable);
            }
        }
    }
    Material mat_anim; MeshRenderer mr;
    [Serializable]
    public struct MaterialProperty
    {
        public string name;
        public Type type;
        public MaterialProperty(string name, Type type) : this()
        {
            this.name = name;
            this.type = type;
        }
        public enum Type
        {
            Color = 0,
            Vector = 1,
            Float = 2,
            Range = 3,
            Texture = 4,
            Int = 5
        }
        public void Apply(Material material, MaterialPropertyBlock block)
        {
	        if (!material.HasProperty(name)) return;
            switch (type)
            {
                case Type.Color:
                    var color = block.GetColor(name);
                    if (color != default)
                    {
                        material.SetColor(name, color);
                    }

                    break;
                case Type.Vector:
                    var vector = block.GetVector(name);
                    if (vector != default)
                    {
                        material.SetVector(name, vector);
                    }

                    break;
                case Type.Float:
                case Type.Range:
	                var value = block.GetFloat(name);
	                material.SetFloat(name, value);

                    break;
                case Type.Texture:
                    var tex = block.GetTexture(name);
                    if (tex != default(Texture))
                    {
                        material.SetTexture(name, tex);
                    }
                    break;
            }
        }
    }
    [SerializeField, HideInInspector]
    public List<MaterialProperty> AnimProperties = new List<MaterialProperty>();
    private void RequireAnim(Material material)
    {
        if (!mat_anim)
        {
            mat_anim = material;
            mat_anim = GameObject.Instantiate(material);
            mat_anim.name = material.name + "_Anim";
            mat_anim.hideFlags = HideFlags.HideAndDontSave;
            mr = this.gameObject.GetComponent<MeshRenderer>();
            if (!mr)
            {
                mr = this.gameObject.AddComponent<MeshRenderer>();
                mr.hideFlags =  HideFlags.NotEditable;
            }
            mr.enabled = false;
        }
        ApplyAnimatableProperties();
        UIVFXs.Add(this);
    }
    private void ReleaseAnim(bool doDestory=true)
    {
        if (doDestory)
        {
            if (mr)
            {
                DestroyImmediate(mr);
                mr = null;
            }
        }
        if (mat_anim)
        {
            DestroyImmediate(mat_anim);
            mat_anim = null;
        }
        UIVFXs.Remove(this);
    }
    public void ApplyAnimatableProperties()
    {
        if (!Animatable || !this.isActiveAndEnabled) return;
        if (sharedPropertyBlock == null)
        {
            sharedPropertyBlock = new MaterialPropertyBlock();
        }
        if (!mat_anim) return;
        if (mr)
        {
            mr.GetPropertyBlock(sharedPropertyBlock);
        }
#if UNITY_EDITOR
        if (sharedPropertyBlock.isEmpty)
        {
            mat_anim.CopyPropertiesFromMaterial(graphic.material);
        }
        else if(UnityEditor.AnimationMode.InAnimationMode())
        {
            Profiler.BeginSample("[EditorOnly] RecordAnimPropertis");
            List<MaterialProperty> properties = new List<MaterialProperty>();
            var shader = graphic.material.shader;
            var count = shader.GetPropertyCount();
            bool changed = false;
            for (int i = 0; i < count; i++)
            {
                var propName = shader.GetPropertyName(i);
                var propType = shader.GetPropertyType(i);
                if (propType == UnityEngine.Rendering.ShaderPropertyType.Texture)
                {
                    //������ͼ �����޷�key ��ͼ����ֻ���޸���ͼ��Tiling/Offset
                    propName = propName + "_ST";
                    propType = UnityEngine.Rendering.ShaderPropertyType.Vector;
                }
#if UNITY_2021_1_OR_NEWER
                if (sharedPropertyBlock.HasProperty(propName))
#else
                //�ɰ汾unityû�� Has���� ���ǵ�����ֻ��Ҫ��¼�ı�Ĳ��� �����Լ����һ��
                bool HasProperty(string name, UnityEngine.Rendering.ShaderPropertyType propertyType)
                {
                    switch (propertyType)
                    {
                        case UnityEngine.Rendering.ShaderPropertyType.Color: return sharedPropertyBlock.GetColor(name) != default(Color);
                        case UnityEngine.Rendering.ShaderPropertyType.Float:
                        case UnityEngine.Rendering.ShaderPropertyType.Range:
                            return sharedPropertyBlock.GetFloat(name) != default(float);
                        case UnityEngine.Rendering.ShaderPropertyType.Vector: return sharedPropertyBlock.GetVector(name) != default(Vector4);
                    }
                    return false;
                }
                if (HasProperty(propName, propType))
#endif
                {
                    if (AnimProperties.Count > properties.Count)
                    {
                        changed |= AnimProperties[properties.Count].name != propName || AnimProperties[properties.Count].type != (MaterialProperty.Type)propType;
                    }
                    properties.Add(new VFXImage.MaterialProperty(propName, (MaterialProperty.Type)propType));
                }
            }
            changed |= AnimProperties.Count != properties.Count;
            if (changed)
            {
                AnimProperties = properties;
                UnityEditor.EditorUtility.SetDirty(this);
            }
            Profiler.EndSample();
        }
#endif
        if (sharedPropertyBlock.isEmpty) return;
        foreach (var prop in AnimProperties)
        {
            prop.Apply(mat_anim, sharedPropertyBlock);
        }
        sharedPropertyBlock.Clear();
    }
    //Static animation update
    private static MaterialPropertyBlock sharedPropertyBlock;
	private static readonly HashSet<VFXImage> UIVFXs = new HashSet<VFXImage>();
    static VFXImage()
    {
        Canvas.willRenderCanvases -= UpdateAnim;
        Canvas.willRenderCanvases += UpdateAnim;
    }
    private static void UpdateAnim()
    {
        foreach (var vfx in UIVFXs)
        {
            if(vfx)
                vfx.ApplyAnimatableProperties();
        }
    }
    protected override void OnDisable()
    {
        base.OnDisable();
        if (graphic != null)
            graphic.SetMaterialDirty();
        ReleaseAnim(false);
    }
    protected override void OnDestroy()
    {
        base.OnDestroy();
        ReleaseAnim(false);
    }
    #endregion

#if UNITY_EDITOR
    protected override void OnValidate()
    {
        base.OnValidate();
        if (graphic != null)
            graphic.SetMaterialDirty();
        if (animatable)
        {
            ApplyAnimatableProperties();
        }
    }
#endif
}
