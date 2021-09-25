using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PresenceManager : MonoBehaviour
{
    [SerializeField] Material PresenceOutput;
    [SerializeField] RenderTexture LastFrameSource;

    [SerializeField] Vector4 PresenceTextureScale;
    [SerializeField] Vector4 PresenceTextureOrigin;

    Texture2D LastFrameCopy;

    // Start is called before the first frame update
    void Start()
    {
        LastFrameCopy = new Texture2D(LastFrameSource.width, LastFrameSource.height,
                                      LastFrameSource.graphicsFormat, 
                                      UnityEngine.Experimental.Rendering.TextureCreationFlags.None);
    }

    // Update is called once per frame
    void Update()
    {
        Graphics.CopyTexture(LastFrameSource, LastFrameCopy);
        Shader.SetGlobalTexture("_LastFrameTexture", LastFrameCopy);

        Shader.SetGlobalVector("_PresenceTextureScale", PresenceTextureScale);
        Shader.SetGlobalVector("_PresenceTextureOrigin", PresenceTextureOrigin);
    }
}
