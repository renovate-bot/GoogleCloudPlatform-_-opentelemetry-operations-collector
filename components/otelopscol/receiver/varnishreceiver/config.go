// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package varnishreceiver

import (
	"fmt"
	"os"

	"go.opentelemetry.io/collector/scraper/scraperhelper"

	"github.com/GoogleCloudPlatform/opentelemetry-operations-collector/components/otelopscol/receiver/varnishreceiver/internal/metadata"
)

// Config defines configuration for varnish metrics receiver.
type Config struct {
	scraperhelper.ControllerConfig `mapstructure:",squash"`
	Metrics                        metadata.MetricsConfig `mapstructure:"metrics"`
	CacheDir                       string                 `mapstructure:"cache_dir"`
	ExecDir                        string                 `mapstructure:"exec_dir"`
}

// Validate validates the config.
func (c *Config) Validate() error {
	if c.CacheDir != "" {
		if _, err := os.Stat(c.CacheDir); err != nil {
			return fmt.Errorf(`"cache_dir" does not exists: %w`, err)
		}
	}
	if c.ExecDir != "" {
		if _, err := os.Stat(c.ExecDir); err != nil {
			return fmt.Errorf(`"exec_dir" does not exists: %w`, err)
		}
	}

	return nil
}
