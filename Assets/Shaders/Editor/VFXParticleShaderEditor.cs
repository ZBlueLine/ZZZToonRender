using SeanLib.CoreEditor;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace SeanLib.ShaderLab
{
    public class VFXParticleShaderEditor : ParticleShaderEditor
    {
        const string K_CustomVertStreams = "_CUSTOM_VERTSTREAMS";
        const string K_Rim = "_RIM_ON";
        const string K_Lighting = "_LIGHTING_ON";
        public override bool NeedCustomVertexSreams => base.NeedCustomVertexSreams|| NeedCenter|| NeedCustomData;
        public bool NeedCustomData => Target.IsKeywordEnabled(K_CustomVertStreams);
        public bool NeedCenter => false;// Target.IsKeywordEnabled(K_Lighting);
        protected override void ValidateParticleModules()
        {
            base.ValidateParticleModules();
            if(currentActiveParticleSystem)
            {
                //Undo.RecordObject(currentActiveParticleSystem, "Enable Custom VertStreams");
                if (!currentActiveParticleSystem.customData.enabled && Target.IsKeywordEnabled(K_CustomVertStreams))
                {
                    var custom = currentActiveParticleSystem.customData;
                    custom.enabled = true;
                }
            }
        }
        protected override void ComposeCustomVertexSreams(List<ParticleSystemVertexStream> ReqStreams)
        {
            base.ComposeCustomVertexSreams(ReqStreams);
            ReqStreams.Clear();
            OnGUIUtility.Layout.Header("Require Vertex Streams");
            GUILayout.Label("Postion(POSITION.xyz)");
            ReqStreams.Add(ParticleSystemVertexStream.Position);
            GUILayout.Label("Color(COLOR.xyzw)");
            ReqStreams.Add(ParticleSystemVertexStream.Color);
            GUILayout.Label("Normal(NORMAL.xyzw)");
            ReqStreams.Add(ParticleSystemVertexStream.Normal);
            if (Target.IsKeywordEnabled(K_NormalMap))
            {
                GUILayout.Label("Tangent(TANGENT.xyzw)");
                ReqStreams.Add(ParticleSystemVertexStream.Tangent);
            }
            //list 
            GUILayout.Label("UV(TEXCOORD0.xy)");
            ReqStreams.Add(ParticleSystemVertexStream.UV);
            //TODO:占位符 
            ReqStreams.Add(ParticleSystemVertexStream.AgePercent);
            ReqStreams.Add(ParticleSystemVertexStream.Speed);
            GUILayout.Label("UV2(TEXCOORD1.xy)");
            ReqStreams.Add(ParticleSystemVertexStream.UV2);
            //TODO:占位符
            ReqStreams.Add(ParticleSystemVertexStream.StableRandomX);
            ReqStreams.Add(ParticleSystemVertexStream.VaryingRandomX);
            if (NeedCustomData)
            {
                GUILayout.Label("Custom1.xyzw(TEXCOORD2.xyzw)");
                ReqStreams.Add(ParticleSystemVertexStream.Custom1XYZW);
                GUILayout.Label("Custom2.xyzw(TEXCOORD3.xyzw)");
                ReqStreams.Add(ParticleSystemVertexStream.Custom2XYZW);
            }
            if (NeedCenter)
            {
                GUILayout.Label(NeedCustomData?"Center(TEXCOORD4.xyz)": "Center(TEXCOORD2.xyz)");
                RequireStreams.Add(ParticleSystemVertexStream.Center);
                GUILayout.Label(NeedCustomData ? "SizeX(TEXCOORD4.w)" : "SizeX(TEXCOORD2.w)");
                RequireStreams.Add(ParticleSystemVertexStream.SizeX);
            }
        }
    }
}