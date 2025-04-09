using System;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace UnityEngine.Rendering.Universal
{
    [Serializable, VolumeComponentMenu("Custom/ToonToneMapping")]
    public class ToonToneMappingPostProcess : VolumeComponent, IPostProcessComponent
    {
        public BoolParameter EnableToonToneMapping = new BoolParameter(false);
        public ClampedFloatParameter _FilmSlopes = new ClampedFloatParameter(1, 0, 3);
        public ClampedFloatParameter _FilmToest = new ClampedFloatParameter(1, 0, 3);
        public ClampedFloatParameter _FilmShoulderg = new ClampedFloatParameter(0.32f, 0, 3);
        public ClampedFloatParameter _FilmShouldergt = new ClampedFloatParameter(0.32f, 0, 3);
        public ClampedFloatParameter _FilmBlackClipe = new ClampedFloatParameter(1.33f, 0, 3);
        public ClampedFloatParameter _FilmBlackClipet = new ClampedFloatParameter(0, 0, 3);

        public bool IsActive() => EnableToonToneMapping == true;
        public bool IsTileCompatible() => false;
    }
}