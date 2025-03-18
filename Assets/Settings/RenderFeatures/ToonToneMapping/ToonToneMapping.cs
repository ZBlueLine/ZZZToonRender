using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ToonToneMapping : ScriptableRendererFeature
{

    class ToonToneMappingPass : ScriptableRenderPass
    {
        private Material mToonToneMappingMaterial;
        private RenderTargetIdentifier m_Source;
        private RenderTargetHandle m_TempTexture;
        private string m_ProfilerTag;
        private ToonToneMappingPostProcess m_ToonToneMappingPostProcess;

        public ToonToneMappingPass(Material toonToneMappingMaterial)
        {
            mToonToneMappingMaterial = toonToneMappingMaterial;
            m_TempTexture.Init("_TempToonToneMapTexture");
            m_ProfilerTag = "Toon Tone Mapping";
        }
        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in a performant manner.
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
        }

        // Here you can implement the rendering logic.
        // Use <c>ScriptableRenderContext</c> to issue drawing commands or execute command buffers
        // https://docs.unity3d.com/ScriptReference/Rendering.ScriptableRenderContext.html
        // You don't have to call ScriptableRenderContext.submit, the render pipeline will call it at specific points in the pipeline.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (mToonToneMappingMaterial == null || !renderingData.cameraData.postProcessEnabled)
                return;

            m_ToonToneMappingPostProcess = VolumeManager.instance.stack.GetComponent<ToonToneMappingPostProcess>();
            if (!m_ToonToneMappingPostProcess.IsActive())
                return;

            mToonToneMappingMaterial.SetFloat(_FilmSlopes, m_ToonToneMappingPostProcess._FilmSlopes.value);
            mToonToneMappingMaterial.SetFloat(_FilmToest, m_ToonToneMappingPostProcess._FilmToest.value);
            mToonToneMappingMaterial.SetFloat(_FilmShoulderg, m_ToonToneMappingPostProcess._FilmShoulderg.value);
            mToonToneMappingMaterial.SetFloat(_FilmShouldergt, m_ToonToneMappingPostProcess._FilmShouldergt.value);
            mToonToneMappingMaterial.SetFloat(_FilmBlackClipe, m_ToonToneMappingPostProcess._FilmBlackClipe.value);
            mToonToneMappingMaterial.SetFloat(_FilmBlackClipet, m_ToonToneMappingPostProcess._FilmBlackClipet.value);
            m_Source = renderingData.cameraData.renderer.cameraColorTarget;
            CommandBuffer cmd = CommandBufferPool.Get(m_ProfilerTag);

            RenderTextureDescriptor descriptor = renderingData.cameraData.cameraTargetDescriptor;
            descriptor.depthBufferBits = 0; 
            cmd.GetTemporaryRT(m_TempTexture.id, descriptor, FilterMode.Bilinear);

            cmd.Blit(m_Source, m_TempTexture.Identifier(), mToonToneMappingMaterial);
            cmd.Blit(m_TempTexture.Identifier(), m_Source);

            cmd.ReleaseTemporaryRT(m_TempTexture.id);

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        // Cleanup any allocated resources that were created during the execution of this render pass.
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(m_TempTexture.id);
        }
    }

    public static readonly int _FilmSlopes = Shader.PropertyToID("_FilmSlopes");
    public static readonly int _FilmToest = Shader.PropertyToID("_FilmToest");
    public static readonly int _FilmShoulderg = Shader.PropertyToID("_FilmShoulderg");
    public static readonly int _FilmShouldergt = Shader.PropertyToID("_FilmShouldergt");
    public static readonly int _FilmBlackClipe = Shader.PropertyToID("_FilmBlackClipe");
    public static readonly int _FilmBlackClipet = Shader.PropertyToID("_FilmBlackClipet");
    ToonToneMappingPass m_ScriptablePass;
    public Shader ToonToneMappingShader;

    /// <inheritdoc/>
    public override void Create()
    {
        if (ToonToneMappingShader != null)
        {
            m_ScriptablePass = new ToonToneMappingPass(new Material(ToonToneMappingShader));
        }

        // Configures where the render pass should be injected.
        m_ScriptablePass.renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
    }

    // Here you can inject one or multiple render passes in the renderer.
    // This method is called when setting up the renderer once per-camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(m_ScriptablePass);
    }
}