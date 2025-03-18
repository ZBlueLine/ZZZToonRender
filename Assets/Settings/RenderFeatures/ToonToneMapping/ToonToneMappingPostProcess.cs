using System;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace UnityEngine.Rendering.Universal
{
    [Serializable, VolumeComponentMenu("Custom/ToonToneMapping")]
    public class ToonToneMappingPostProcess : VolumeComponent, IPostProcessComponent
    {
        public BoolParameter EnableToonToneMapping = new BoolParameter(false);
        public MinFloatParameter _FilmSlopes = new MinFloatParameter(1, 0);
        public MinFloatParameter _FilmToest = new MinFloatParameter(1, 0);
        public MinFloatParameter _FilmShoulderg = new MinFloatParameter(0.32f, 0);
        public MinFloatParameter _FilmShouldergt = new MinFloatParameter(0.32f, 0);
        public MinFloatParameter _FilmBlackClipe = new MinFloatParameter(1.33f, 0);
        public MinFloatParameter _FilmBlackClipet = new MinFloatParameter(0, 0);

        public bool IsActive() => EnableToonToneMapping == true;
        public bool IsTileCompatible() => false;
    }
}